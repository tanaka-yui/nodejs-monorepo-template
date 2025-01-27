import type { QueryClient } from '@tanstack/react-query'
import type { FC } from 'react'
import type * as React from 'react'
import { AppTheme } from '~/components/layouts/MainLayout/theme'
import { useInitializeLocal } from '~/locales/hooks/useInitializeLocal'
import { ApiClientProvider } from '~/providers/ApiClientProvider'
import { AppRouterProvider } from '~/providers/AppRouterProvider'
import { routeTree } from '~/routeTree.gen'
import '~/locales/i18n'

export const RootProvider: FC = () => {
  useInitializeLocal()
  return (
    <AppTheme>
      <ApiClientProvider baseUrl={import.meta.env.VITE_API_URL}>
        {(queryClient: QueryClient): React.ReactNode => (
          <AppRouterProvider queryClient={queryClient} routeTree={routeTree} />
        )}
      </ApiClientProvider>
    </AppTheme>
  )
}
