import TextField from '@mui/material/TextField'
import { useNavigate } from '@tanstack/react-router'
import type { FC } from 'react'
import { useTranslation } from 'react-i18next'
import { ButtonPrimary } from '~/components/general/ButtonPrimary'
import { FormField } from '~/components/general/FormField'
import { MainLayout } from '~/components/layouts/MainLayout'
import { useCreate } from '~/pages/users/features/UserRegister/hooks/useCreate'
import { type Schema, useForm } from '~/pages/users/features/UserRegister/hooks/useForm'

export const UserRegister: FC = () => {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const {
    handleSubmit,
    register,
    formState: { errors },
  } = useForm()

  const { mutate } = useCreate({
    onSuccess: () => {
      navigate({ to: '/users' })
    },
  })

  const onSubmit = handleSubmit((data: Schema) => {
    mutate(data)
  })

  return (
    <MainLayout>
      <FormField error={errors?.name?.message}>
        <TextField label={t('label.name')} {...register('name')} fullWidth error={!!errors?.name} required />
      </FormField>
      <ButtonPrimary onClick={onSubmit}>{t('action.create')}</ButtonPrimary>
    </MainLayout>
  )
}
