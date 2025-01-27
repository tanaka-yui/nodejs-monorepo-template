import { createLazyFileRoute } from '@tanstack/react-router'

import { UserRegister } from '~/pages/users/features/UserRegister'

export const Route = createLazyFileRoute('/_authenticated/users/register')({
  component: UserRegister,
})
