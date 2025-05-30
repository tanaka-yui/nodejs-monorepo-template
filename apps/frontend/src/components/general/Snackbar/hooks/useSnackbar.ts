import { atom, useAtom } from 'jotai'

type Status = 'success' | 'error' | 'warning' | 'info'

type SnackbarState = {
  isOpen: boolean
  message: string
  status?: Status
  hideDuration?: number
}

const snackBarState = atom<SnackbarState>({
  isOpen: false,
  message: '',
  status: 'success',
  hideDuration: 3000,
})

export const useSnackbarAtom = () => useAtom(snackBarState)

type SnackbarOptions = {
  message: string
  status: Status
  hideDuration?: number
}

export const useSnackbar = (props: SnackbarOptions) => {
  const [state, setState] = useAtom(snackBarState)

  const onOpenSnackbar = (message?: string) => {
    setState({
      ...props,
      message: message ?? props.message,
      isOpen: true,
    })
  }

  const onCloseSnackbar = () => {
    setState({
      ...state,
      isOpen: false,
    })
  }

  return { onOpen: onOpenSnackbar, onClose: onCloseSnackbar, isOpen: state.isOpen }
}
