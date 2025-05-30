import Typography from '@mui/material/Typography'
import type { TypographyProps } from '@mui/material/Typography'
import type { FC } from 'react'

export const Heading4: FC<TypographyProps> = ({ children, ...props }) => {
  return (
    <Typography variant="h4" {...props} gutterBottom>
      {children}
    </Typography>
  )
}
