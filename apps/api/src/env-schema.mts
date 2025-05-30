import type { FastifyEnvOptions } from '@fastify/env'

declare module 'fastify' {
  interface FastifyInstance {
    config: {
      PORT: number
      HOST: string
      LOG_LEVEL: string
      DB_USERNAME: string
      DB_PASSWORD: string
      DB_HOST_WRITER: string
      DB_HOST_READER: string
      DB_PORT: string
      DB_DATABASE: string
      DB_LOG_LEVEL: string
      HELMET_ENABLE: boolean
      NO_CACHE_ENABLE: boolean
      SWAGGER_ENABLE: boolean
    }
  }
}

export const options: FastifyEnvOptions = {
  dotenv: true,
  schema: {
    type: 'object',
    required: ['PORT', 'HOST'],
    properties: {
      PORT: {
        type: 'number',
        default: 3000,
      },
      HOST: {
        type: 'string',
        default: '0.0.0.0',
      },
      LOG_LEVEL: {
        type: 'string',
        default: 'info',
      },
      DB_USERNAME: {
        type: 'string',
      },
      DB_PASSWORD: {
        type: 'string',
      },
      DB_HOST_WRITER: {
        type: 'string',
      },
      DB_HOST_READER: {
        type: 'string',
      },
      DB_PORT: {
        type: 'string',
      },
      DB_DATABASE: {
        type: 'string',
      },
      DB_LOG_LEVEL: {
        type: 'string',
      },
      HELMET_ENABLE: {
        type: 'boolean',
        default: false,
      },
      NO_CACHE_ENABLE: {
        type: 'boolean',
        default: false,
      },
      SWAGGER_ENABLE: {
        type: 'boolean',
        default: false,
      },
    },
  },
}
