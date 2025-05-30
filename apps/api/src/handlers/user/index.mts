import type { FastifyInstance, FastifyRequest } from 'fastify'
import type { UserUsecase } from '~/usecase/user/index.mjs'

export class UserHandler {
  private readonly route: FastifyInstance
  private readonly userUsecase: UserUsecase

  constructor({
    route,
    userUsecase,
  }: {
    route: FastifyInstance
    userUsecase: UserUsecase
  }) {
    this.route = route
    this.userUsecase = userUsecase
    this.getUser = this.getUser.bind(this)
    this.createUser = this.createUser.bind(this)
    this.updateUser = this.updateUser.bind(this)

    // Register routes
    this.route.get('/users/:id', {
      schema: {
        tags: ['user'],
        operationId: 'getUser',
        summary: 'Get user by id',
        description: 'Get user by id',
        params: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              description: 'user id',
            },
          },
        },
        response: {
          200: {
            description: 'default response',
            type: 'object',
            properties: {
              id: {
                type: 'string',
                description: 'user id',
              },
              name: {
                type: 'string',
                description: 'user name',
              },
            },
          },
        },
      },
      handler: this.getUser,
    })

    this.route.addSchema({
      $id: 'user',
      type: 'object',
      properties: {
        id: { type: 'string' },
        name: { type: 'string' },
      },
    })

    this.route.post('/users', {
      schema: {
        tags: ['user'],
        operationId: 'createUser',
        summary: 'Create user',
        description: 'Create user',
        body: {
          type: 'object',
          properties: {
            name: { type: 'string' },
          },
        },
        response: {
          200: {
            description: 'default response',
            $ref: 'user#',
          },
        },
      },
      handler: this.createUser,
    })

    this.route.put('/users/:id', {
      schema: {
        tags: ['user'],
        operationId: 'updateUser',
        summary: 'Update user',
        description: 'Update user',
        params: {
          type: 'object',
          properties: {
            id: { type: 'string' },
          },
        },
        body: {
          type: 'object',
          properties: {
            name: { type: 'string' },
          },
        },
      },
      handler: this.updateUser,
    })
  }

  async getUser(request: FastifyRequest<{ Params: { id: string } }>) {
    const { id } = request.params
    return this.userUsecase.getUser(id)
  }

  async createUser(request: FastifyRequest<{ Body: { name: string } }>) {
    const { name } = request.body
    return this.userUsecase.createUser({ name })
  }

  async updateUser(request: FastifyRequest<{ Body: { name: string }; Params: { id: string } }>) {
    const { id } = request.params
    const { name } = request.body
    return this.userUsecase.updateUser({ id, name })
  }
}
