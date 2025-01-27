import Typography from '@mui/material/Typography'
import type { TypographyProps } from '@mui/material/Typography'
import type { FC } from 'react'

export const Heading1: FC<TypographyProps> = ({ children, ...props }) => {
  return (
    <Typography variant="h1" {...props} gutterBottom>
      {children}
    </Typography>
  )
}
