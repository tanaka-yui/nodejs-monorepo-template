import { Outlet, createRootRouteWithContext } from '@tanstack/react-router'
import { TanStackRouterDevtools } from '@tanstack/router-devtools'
import { Snackbar } from '~/components/general/Snackbar'
import { ErrorLayout } from '~/components/layouts/ErrorLayout'

export const Route = createRootRouteWithContext()({
  component: () => {
    return (
      <>
        <Outlet />
        <Snackbar />
        <TanStackRouterDevtools position="bottom-right" />
      </>
    )
  },
  notFoundComponent: () => <ErrorLayout status={404} />,
})
