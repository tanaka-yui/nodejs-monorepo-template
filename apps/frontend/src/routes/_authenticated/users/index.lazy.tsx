import { createLazyFileRoute } from '@tanstack/react-router'

import { UserList } from '~/pages/users/features/UserList'

export const Route = createLazyFileRoute('/_authenticated/users/')({
  component: UserList,
})
