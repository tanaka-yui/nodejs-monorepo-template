import { useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useSnackbar } from '~/components/general/Snackbar/hooks/useSnackbar'
import type { UpdateUserRequest } from '~/gen/api'
import { UserApi } from '~/gen/api/apis/UserApi'
import { openapiConfig } from '~/helpers/openapiHelper'

type UseUpdateProps = {
  id: string
  onSuccess: () => void
}

export const useUpdate = ({ id, onSuccess }: UseUpdateProps) => {
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
    mutationFn: (params: UpdateUserRequest) => {
      return new UserApi(openapiConfig).updateUser({
        id,
        body: {
          name: params.name,
        },
      })
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
