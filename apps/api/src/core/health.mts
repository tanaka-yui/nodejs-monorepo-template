import type { FastifyInstance } from 'fastify'

export class HealthHandler {
  private readonly fastify: FastifyInstance

  constructor({ fastify }: { fastify: FastifyInstance }) {
    this.fastify = fastify
    this.fastify.addHook('onRoute', (opts) => {
      if (opts.path === '/health') {
        opts.logLevel = 'silent'
      }
    })
    this.fastify.get('/health', this.getHealth)
  }

  async favicon() {
    return 'OK'
  }

  async getHealth() {
    return 'OK'
  }
}
