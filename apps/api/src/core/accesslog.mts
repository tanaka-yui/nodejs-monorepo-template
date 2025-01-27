import type { FastifyReply, FastifyRequest } from 'fastify'

export const accessLog = (request: FastifyRequest, _: FastifyReply, done: () => void) => {
  const clientIp = request.headers['x-forwarded-for']
    ? Array.isArray(request.headers['x-forwarded-for'])
      ? request.headers['x-forwarded-for'][0]?.trim()
      : (request.headers['x-forwarded-for'] as string).split(',')[0]?.trim()
    : request.ip

  request.log.info({
    msg: 'incoming request',
    method: request.method,
    url: request.url,
    ip: clientIp,
    userAgent: request.headers['user-agent'],
    query: request.query,
    requestId: request.id,
  })

  done()
}
