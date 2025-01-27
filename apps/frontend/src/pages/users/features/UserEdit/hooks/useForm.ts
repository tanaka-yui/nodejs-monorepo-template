import { yupResolver } from '@hookform/resolvers/yup'
import { useEffect } from 'react'
import { type UseFormReturn, useForm as useHookForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import * as yup from 'yup'
import type { GetUser200Response } from '~/gen/api/'

export type Schema = {
  id: string
  name: string
}

export const useForm = (data?: GetUser200Response): UseFormReturn<Schema> => {
  const { t } = useTranslation()
  const scheme = yup.object<Schema>().shape({
    id: yup.string().required(),
    name: yup.string().label(t('label.name')).required(),
  })

  const form = useHookForm<Schema>({
    mode: 'onSubmit',
    resolver: yupResolver(scheme),
    defaultValues: makeDefaultValues(),
  })

  useEffect(() => {
    form.reset(makeDefaultValues(data))
  }, [form, data])

  return form
}

const makeDefaultValues = (data?: GetUser200Response): Schema => {
  return {
    id: String(data?.id ?? ''),
    name: data?.name ?? '',
  }
}
