import { Button, type ButtonProps } from '@mui/material'
import type { FC } from 'react'

export const ButtonPrimary: FC<ButtonProps> = ({ children, ...props }) => {
  return (
    <Button color="primary" variant="contained" {...props}>
      {children}
    </Button>
  )
}
