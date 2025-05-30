import { FormControl } from '@mui/material'
import Box from '@mui/material/Box'
import Typography from '@mui/material/Typography'
import type { FC, ReactNode } from 'react'

type FormFieldProps = {
  children: ReactNode
  error?: string
}

export const FormField: FC<FormFieldProps> = ({ children, error }) => {
  return (
    <FormControl error={!!error}>
      <Box>{children}</Box>
      {error && (
        <Typography marginTop={1} variant="caption" color="error">
          {error}
        </Typography>
      )}
    </FormControl>
  )
}
