import { yupResolver } from '@hookform/resolvers/yup'
import { type UseFormReturn, useForm as useHookForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import * as yup from 'yup'

export type Schema = {
  name: string
}

export const useForm = (): UseFormReturn<Schema> => {
  const { t } = useTranslation()
  const scheme = yup.object<Schema>().shape({
    name: yup.string().label(t('label.name')).required(),
  })

  return useHookForm<Schema>({
    mode: 'onSubmit',
    resolver: yupResolver(scheme),
    defaultValues: {
      name: '',
    },
  })
}
