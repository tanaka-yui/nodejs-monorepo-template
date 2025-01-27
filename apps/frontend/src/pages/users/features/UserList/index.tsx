import { useNavigate } from '@tanstack/react-router'
import type { FC } from 'react'
import { useTranslation } from 'react-i18next'
import { ButtonPrimary } from '~/components/general/ButtonPrimary'
import { MainLayout } from '~/components/layouts/MainLayout'

export const UserList: FC = () => {
  const { t } = useTranslation()
  const navigate = useNavigate()
  return (
    <MainLayout>
      <ButtonPrimary onClick={() => navigate({ to: '/users/register' })}>{t('menu.user_register')}</ButtonPrimary>
    </MainLayout>
  )
}
