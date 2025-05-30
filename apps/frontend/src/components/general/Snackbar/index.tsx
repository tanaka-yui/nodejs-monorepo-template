import CloseIcon from '@mui/icons-material/Close'
import IconButton from '@mui/material/IconButton'
import Slide, { type SlideProps } from '@mui/material/Slide'
import MuiSnackbar from '@mui/material/Snackbar'
import { useSnackbarAtom } from '~/components/general/Snackbar/hooks/useSnackbar'

function SlideTransition(props: SlideProps) {
  return <Slide {...props} direction="down" />
}

export const Snackbar = () => {
  const [state, setState] = useSnackbarAtom()

  const onClose = () => {
    setState({
      ...state,
      isOpen: false,
    })
  }

  return (
    <MuiSnackbar
      open={state.isOpen}
      autoHideDuration={state.hideDuration ?? 3000}
      onClose={onClose}
      anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      TransitionComponent={SlideTransition}
      message={state.message}
      action={
        <IconButton size="small" aria-label="close" color="inherit" onClick={onClose}>
          <CloseIcon fontSize="small" />
        </IconButton>
      }
    />
  )
}
