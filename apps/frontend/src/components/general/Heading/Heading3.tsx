import Typography from '@mui/material/Typography'
import type { TypographyProps } from '@mui/material/Typography'
import type { FC } from 'react'

export const Heading3: FC<TypographyProps> = ({ children, ...props }) => {
  return (
    <Typography variant="h3" {...props} gutterBottom>
      {children}
    </Typography>
  )
}
