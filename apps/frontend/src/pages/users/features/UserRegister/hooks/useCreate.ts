import { useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useSnackbar } from '~/components/general/Snackbar/hooks/useSnackbar'
import { UserApi } from '~/gen/api/apis/UserApi'
import type { UsersPostRequest } from '~/gen/api/models/UsersPostRequest'
import { openapiConfig } from '~/helpers/openapiHelper'

type UseCreateProps = {
  onSuccess: () => void
}

export const useCreate = ({ onSuccess }: UseCreateProps) => {
  const { t } = useTranslation()

  const { onOpen: onOpenSuccess } = useSnackbar({
    message: t('message.create_success', {
      name: t('label.user'),
    }),
    status: 'success',
  })

  const { onOpen: onOpenError } = useSnackbar({
    message: t('message.create_failed', {
      name: t('label.user'),
    }),
    status: 'error',
  })

  return useMutation({
    mutationFn: (params: UsersPostRequest) => {
      return new UserApi(openapiConfig).createUser({ body: params })
    },
    onSuccess: () => {
      onOpenSuccess()
      onSuccess()
    },
    onError: () => {
      onOpenError()
    },
  })
}
