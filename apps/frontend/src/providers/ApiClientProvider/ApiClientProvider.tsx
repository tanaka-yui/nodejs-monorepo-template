import { type FC, type ReactNode, useState } from 'react'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

import { API_STALE_TIME_DEFAULT } from '~/providers/ApiClientProvider/option'

type ApiClientProviderProps = {
  baseUrl: string
  children: ReactNode | ((queryClient: QueryClient) => ReactNode)
  showDevTools?: boolean
}

export const ApiClientProvider: FC<ApiClientProviderProps> = ({ children, showDevTools = true }) => {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: API_STALE_TIME_DEFAULT,
            refetchOnWindowFocus: false,
            throwOnError: true,
          },
        },
      }),
  )

  return (
    <QueryClientProvider client={queryClient}>
      {showDevTools && <ReactQueryDevtools initialIsOpen={false} />}
      {children instanceof Function ? children(queryClient) : children}
    </QueryClientProvider>
  )
}
