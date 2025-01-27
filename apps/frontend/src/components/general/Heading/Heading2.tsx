import Typography from '@mui/material/Typography'
import type { TypographyProps } from '@mui/material/Typography'
import type { FC } from 'react'

export const Heading2: FC<TypographyProps> = ({ children, ...props }) => {
  return (
    <Typography variant="h2" {...props} gutterBottom>
      {children}
    </Typography>
  )
}
