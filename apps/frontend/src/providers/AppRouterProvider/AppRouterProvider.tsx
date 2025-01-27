import * as React from 'react'

import type { QueryClient } from '@tanstack/react-query'
import { type AnyRoute, RouterProvider, createRouter } from '@tanstack/react-router'

type AppRouterProviderProps = {
  routeTree: AnyRoute
  queryClient: QueryClient
}

export const AppRouterProvider: React.FC<AppRouterProviderProps> = ({ routeTree, queryClient }) => {
  const router = React.useMemo(() => {
    return createRouter({
      routeTree,
      context: {
        queryClient,
      },
    })
  }, [routeTree, queryClient])

  return <RouterProvider router={router} />
}
