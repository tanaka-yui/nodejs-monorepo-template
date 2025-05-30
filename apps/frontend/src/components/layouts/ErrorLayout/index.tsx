import type { FC } from 'react'
import { NotFound } from '~/components/layouts/ErrorLayout/NotFound.tsx'

type ErrorLayoutProps = {
  status: number
}

export const ErrorLayout: FC<ErrorLayoutProps> = ({ status }) => {
  switch (status) {
    case 404:
      return <NotFound />
  }

  return (
    <div>
      <h1>{status}</h1>
    </div>
  )
}
