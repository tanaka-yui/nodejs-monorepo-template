import { ThemeProvider, createTheme } from '@mui/material/styles'
import { type ReactNode, useMemo } from 'react'
import { colorSchemes, shadows, shape, typography } from './colors/primitives'
import { dataDisplayCustomizations } from './components/dataDisplay'
import { feedbackCustomizations } from './components/feedback'
import { inputsCustomizations } from './components/inputs'
import { navigationCustomizations } from './components/navigation'
import { surfacesCustomizations } from './components/surfaces'

type AppThemeProps = {
  children: ReactNode
}

export const AppTheme = ({ children }: AppThemeProps): ReactNode => {
  const theme = useMemo(
    () =>
      createTheme({
        // For more details about CSS variables configuration, see https://mui.com/material-ui/customization/css-theme-variables/configuration/
        cssVariables: {
          colorSchemeSelector: 'data-mui-color-scheme',
          cssVarPrefix: 'template',
        },
        colorSchemes, // Recently added in v6 for building light & dark mode app, see https://mui.com/material-ui/customization/palette/#color-schemes
        typography,
        shadows,
        shape,
        components: {
          ...inputsCustomizations,
          ...dataDisplayCustomizations,
          ...feedbackCustomizations,
          ...navigationCustomizations,
          ...surfacesCustomizations,
        },
      }),
    [],
  )

  return (
    <ThemeProvider theme={theme} disableTransitionOnChange>
      {children}
    </ThemeProvider>
  )
}
