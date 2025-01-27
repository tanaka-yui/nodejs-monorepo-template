import GracefulServer from '@gquittet/graceful-server'

import { Container } from '~/core/container.mjs'

const bootstrap = async () => {
  try {
    const container = new Container()
    const server = await container.initialize()

    const graceful = GracefulServer(server.server, {
      closePromises: [container.destroy],
      timeout: 3000,
    })

    graceful.on(GracefulServer.READY, () => {
      server.log.info('Server is ready')
    })
    graceful.on(GracefulServer.SHUTTING_DOWN, () => {
      server.log.info('Server is shutting down')
    })
    graceful.on(GracefulServer.SHUTDOWN, (error) => {
      server.log.error('Server is down', error)
    })

    await server.listen({ port: server.config.PORT, host: server.config.HOST })
    graceful.setReady()
  } catch (err) {
    console.error(err)
    process.exit(1)
  }
}

bootstrap()
