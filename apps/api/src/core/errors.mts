import type { FastifyReply, FastifyRequest } from 'fastify'

export class NotFoundError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'Not Found'
  }
}

export class BadRequestError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'Bad Request'
  }
}

export class UnauthorizedError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'Unauthorized'
  }
}

export class ForbiddenError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'Forbidden'
  }
}

export class InternalServerError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'InternalServerError'
  }
}

export const errorHandler = (error: Error, req: FastifyRequest, reply: FastifyReply) => {
  if (error instanceof NotFoundError) {
    req.log.info(
      JSON.stringify({
        statusCode: 404,
        message: error.message,
      }),
    )
    reply.status(404).send({
      statusCode: 404,
      message: error.message,
    })
  } else if (error instanceof BadRequestError) {
    req.log.warn(
      JSON.stringify({
        statusCode: 400,
        message: error.message,
      }),
    )
    reply.status(400).send({
      statusCode: 400,
      message: error.message,
    })
  } else if (error instanceof UnauthorizedError) {
    req.log.warn(
      JSON.stringify({
        statusCode: 401,
        message: error.message,
      }),
    )
    reply.status(401).send({
      statusCode: 401,
      message: error.message,
    })
  } else if (error instanceof ForbiddenError) {
    req.log.warn(
      JSON.stringify({
        statusCode: 403,
        message: error.message,
      }),
    )
    reply.status(403).send({
      statusCode: 403,
      message: error.message,
    })
  } else {
    req.log.error(
      JSON.stringify({
        message: error.message,
        stack: error.stack,
      }),
    )
    reply.status(500).send({
      statusCode: 500,
      message: InternalServerError.name,
    })
  }
}
