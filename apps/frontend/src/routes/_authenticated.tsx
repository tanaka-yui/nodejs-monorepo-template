import type { ReactNode } from 'react'

import { Outlet, createFileRoute } from '@tanstack/react-router'

export const Component = (): ReactNode => {
  return (
    <div>
      <Outlet />
    </div>
  )
}

export const Route = createFileRoute('/_authenticated')({
  component: Component,
})
