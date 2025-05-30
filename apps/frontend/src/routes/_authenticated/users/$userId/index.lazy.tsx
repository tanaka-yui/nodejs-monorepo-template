import { createLazyFileRoute } from '@tanstack/react-router'

import { UserEdit } from '~/pages/users/features/UserEdit'

export const Route = createLazyFileRoute('/_authenticated/users/$userId/')({
  component: UserEdit,
})
