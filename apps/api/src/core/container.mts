import { diContainer, fastifyAwilixPlugin } from '@fastify/awilix'
import fastifyEnv from '@fastify/env'
import fastifySwagger from '@fastify/swagger'
import fastifySwaggerUi from '@fastify/swagger-ui'
import helmet from '@fastify/helmet'
import fastifyCaching from '@fastify/caching'
import { type Constructor, InjectionMode, Lifetime, asClass, asValue } from 'awilix'
import Fastify, {
  type FastifyRegisterOptions,
  type RegisterOptions,
  type FastifyBaseLogger,
  type FastifyInstance,
} from 'fastify'
import { DatabaseClient } from '~/clients/database.mjs'
import { accessLog } from '~/core/accesslog.mjs'
import { errorHandler } from '~/core/errors.mjs'
import { HealthHandler } from '~/core/health.mjs'
import { options } from '~/env-schema.mjs'
import { targets as handlers } from '~/handlers/index.mjs'
import { targets as infra } from '~/infra/index.mjs'
import { targets as usecases } from '~/usecase/index.mjs'

// If you want to add a dependency directory, add it here
// biome-ignore lint/suspicious/noExplicitAny: <explanation>
const dependencies: Constructor<any>[] = [...infra, ...usecases]

const toCamelCase = (name: string) => {
  return name.charAt(0).toLowerCase() + name.slice(1)
}

export class Container {
  async initialize(): Promise<FastifyInstance> {
    // Initialize Fastify
    const fastify = Fastify({
      logger: true,
    })
    await fastify.register(fastifyEnv, options)
    fastify.log.level = fastify.config.LOG_LEVEL

    const logger = fastify.log

    // Add access logging
    fastify.addHook('onRequest', accessLog)

    // Set error handler
    fastify.setErrorHandler(errorHandler)

    // Add helmet middleware
    if (fastify.config.HELMET_ENABLE) {
      fastify.register(helmet, {
        contentSecurityPolicy: true,
        crossOriginEmbedderPolicy: true,
        crossOriginResourcePolicy: true,
        strictTransportSecurity: {
          maxAge: 31536000,
          includeSubDomains: true,
          preload: true,
        },
        referrerPolicy: {
          policy: 'no-referrer',
        },
        frameguard: {
          action: 'sameorigin',
        },
        xssFilter: true,
        noSniff: true,
        dnsPrefetchControl: {
          allow: false,
        },
      })
    }

    // Add caching middleware
    if (fastify.config.NO_CACHE_ENABLE) {
      fastify.register(fastifyCaching, {
        privacy: fastifyCaching.privacy.NOCACHE,
      })
    }

    // Initialize DI container
    await fastify.register(fastifyAwilixPlugin, {
      disposeOnClose: true,
      strictBooleanEnforced: true,
      injectionMode: InjectionMode.CLASSIC,
    })

    // Initialize swagger
    if (fastify.config.SWAGGER_ENABLE) {
      await fastify.register(fastifySwagger)
      await fastify.register(fastifySwaggerUi, {
        routePrefix: '/docs',
      })
    }

    // Initialize database client
    const dbClient = new DatabaseClient(
      fastify.config.DB_USERNAME,
      fastify.config.DB_PASSWORD,
      fastify.config.DB_HOST_WRITER,
      fastify.config.DB_HOST_READER,
      fastify.config.DB_PORT,
      fastify.config.DB_DATABASE,
      fastify.config.DB_LOG_LEVEL === 'debug'
        ? {
            query: (event) => {
              logger.debug({
                'debug-query': event,
              })
            },
          }
        : undefined,
    )
    logger.info('Connecting to database')
    const connection = await dbClient.connect()
    logger.info('Connected to database')

    // Register dependencies
    diContainer.register('fastify', asValue(fastify))
    diContainer.register('dbClient', asValue(dbClient))
    diContainer.register('logger', asValue(fastify.log))
    diContainer.register('prismaClient', asValue(connection))

    for (const target of dependencies) {
      const targetName = toCamelCase(target.name)
      logger.info(`Registering ${targetName}`)
      diContainer
        .register(
          targetName,
          asClass(target, {
            lifetime: Lifetime.SINGLETON,
          }),
        )
        .resolve(targetName)
    }

    // Register handlers
    diContainer
      .register(HealthHandler.name, asClass(HealthHandler, { lifetime: Lifetime.SINGLETON }))
      .resolve(HealthHandler.name)

    fastify.register(
      (instance: FastifyInstance, _: FastifyRegisterOptions<RegisterOptions>, done: () => void) => {
        diContainer.register('route', asValue(instance))
        for (const handler of handlers) {
          const handlerName = toCamelCase(handler.name)
          diContainer.register(handlerName, asClass(handler, { lifetime: Lifetime.SINGLETON })).resolve(handlerName)
        }
        done()
      },
      {
        prefix: '/api',
      },
    )

    return fastify
  }

  async destroy() {
    const logger = diContainer.resolve<FastifyBaseLogger>('logger')
    logger.info('Disconnecting from database')
    await diContainer.resolve<DatabaseClient>('dbClient').disconnect()
    logger.info('Disconnected from database')
  }
}
