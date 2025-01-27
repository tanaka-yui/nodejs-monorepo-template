import { Box } from '@mui/material'
import Stack from '@mui/material/Stack'
import type { FC, ReactNode } from 'react'

type MainContentProps = {
  children: ReactNode
}

export const MainContent: FC<MainContentProps> = ({ children }) => {
  return (
    <Box component="main" position="absolute" top={0} left={0} right={0} bottom={0} paddingLeft="280px">
      <Stack
        height="100%"
        sx={{
          alignItems: 'center',
        }}
      >
        <Box position="relative" height="100%" width="100%">
          {children}
        </Box>
      </Stack>
    </Box>
  )
}
