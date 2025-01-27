import HomeRoundedIcon from '@mui/icons-material/HomeRounded'
import { Box, CssBaseline } from '@mui/material'
import { type FC, type ReactNode, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { MainContent } from '~/components/layouts/MainLayout/components/MainContent'
import { SideMenu } from './components/SideMenu'
import { AppTheme } from './theme'

type MainLayoutProps = {
  children: ReactNode
}

export const MainLayout: FC<MainLayoutProps> = ({ children }) => {
  const { t } = useTranslation()
  const mainListItems = useMemo(() => [{ text: t('menu.home'), icon: <HomeRoundedIcon />, path: '/home' }], [t])

  return (
    <AppTheme>
      <CssBaseline enableColorScheme />
      <Box sx={{ display: 'flex' }}>
        <SideMenu items={mainListItems} />
        <MainContent>{children}</MainContent>
      </Box>
    </AppTheme>
  )
}
