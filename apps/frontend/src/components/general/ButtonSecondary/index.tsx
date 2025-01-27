import { Button, type ButtonProps } from '@mui/material'
import type { FC } from 'react'

export const ButtonSecondary: FC<ButtonProps> = ({ children, ...props }) => {
  return (
    <Button color="primary" variant="outlined" {...props}>
      {children}
    </Button>
  )
}
