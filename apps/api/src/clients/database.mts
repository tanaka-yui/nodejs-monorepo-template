import { PrismaClient } from '@prisma/client'
import type { Prisma } from '@prisma/client'
import type { PrismaClient as PrismaClientExtension } from '@prisma/client/extension'
import { readReplicas } from '@prisma/extension-read-replicas'

type PaginationResult<T, A> = {
  items: Prisma.Result<T, A, 'findMany'>
  totalCount: number
}

export type PrismaLog = {
  query: string
  params: Record<string, unknown>
  duration: number
  timestamp: string
}

export interface LogEventHandler {
  query?: (event: PrismaLog) => void
  error?: (event: PrismaLog) => void
  info?: (event: PrismaLog) => void
  warn?: (event: PrismaLog) => void
}

export class DatabaseClient {
  private prisma: PrismaClientExtension

  constructor(
    userName: string,
    password: string,
    hostWriter: string,
    hostReader: string,
    port: string,
    dbName: string,
    logEventHandler?: LogEventHandler,
  ) {
    this.prisma = new PrismaClient({
      errorFormat: 'pretty',
      datasources: {
        db: {
          url: `postgresql://${userName}:${password}@${hostWriter}:${port}/${dbName}?sslmode=disable`,
        },
      },
      log: [
        {
          emit: 'event',
          level: 'query',
        },
        {
          emit: 'event',
          level: 'error',
        },
        {
          emit: 'event',
          level: 'info',
        },
        {
          emit: 'event',
          level: 'warn',
        },
      ],
    })
    if (logEventHandler) {
      this.prisma.$on('query', (event: PrismaLog) => {
        logEventHandler?.query?.(event)
      })
      this.prisma.$on('error', (event: PrismaLog) => {
        logEventHandler?.error?.(event)
      })
      this.prisma.$on('info', (event: PrismaLog) => {
        logEventHandler?.info?.(event)
      })
      this.prisma.$on('warn', (event: PrismaLog) => {
        logEventHandler?.warn?.(event)
      })
    }

    this.prisma
      .$extends(
        readReplicas({
          url: `postgresql://${userName}:${password}@${hostReader}:${port}/${dbName}?schema=public`,
        }),
      )
      .$extends({
        model: {
          $allModels: {
            async paginate<T, A>(
              this: T,
              args: Prisma.Exact<A, Prisma.Args<T, 'findMany'>>,
            ): Promise<PaginationResult<T, A>> {
              const [items, totalCount] = await Promise.all([
                // biome-ignore lint/suspicious/noExplicitAny: <explanation>
                (this as any).findMany({
                  // biome-ignore lint/suspicious/noExplicitAny: <explanation>
                  ...(args as any),
                }),
                // biome-ignore lint/suspicious/noExplicitAny: <explanation>
                (this as any).count({ where: (args as any).where }),
              ])

              return { items, totalCount }
            },
          },
        },
      })
  }

  async connect(): Promise<PrismaClient> {
    await this.prisma.$connect()
    return this.prisma
  }

  async disconnect() {
    await this.prisma.$disconnect()
  }
}
