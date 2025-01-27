import TextField from '@mui/material/TextField'
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from '@tanstack/react-router'
import type { FC } from 'react'
import { useTranslation } from 'react-i18next'
import { ButtonPrimary } from '~/components/general/ButtonPrimary'
import { FormField } from '~/components/general/FormField'
import { MainLayout } from '~/components/layouts/MainLayout'
import { UserApi } from '~/gen/api'
import { openapiConfig } from '~/helpers/openapiHelper'
import { type Schema, useForm } from '~/pages/users/features/UserEdit/hooks/useForm'
import { useUpdate } from '~/pages/users/features/UserEdit/hooks/useUpdate'
import { Route } from '~/routes/_authenticated/users/$userId'

export const UserEdit: FC = () => {
  const { t } = useTranslation()
  const navigate = useNavigate()

  const { userId } = Route.useParams()
  const { data } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => new UserApi(openapiConfig).getUser({ id: userId }),
  })

  const {
    handleSubmit,
    register,
    formState: { errors },
  } = useForm(data)

  const { mutate } = useUpdate({
    id: userId,
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
      <ButtonPrimary onClick={onSubmit}>{t('action.update')}</ButtonPrimary>
    </MainLayout>
  )
}
