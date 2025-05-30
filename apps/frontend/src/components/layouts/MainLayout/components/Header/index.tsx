import Stack from '@mui/material/Stack'
import { ColorModeIconDropdown } from '~/components/layouts/MainLayout/components/ColorModeIconDropdown'

import type { FC } from 'react'
import { type Breadcrumb, NavbarBreadcrumbs } from '~/components/layouts/MainLayout/components/NavbarBreadcrumbs'
import { NotificationButton } from '~/components/layouts/MainLayout/components/NotificationButton'

type HeaderProps = {
  breadcrumbs: Breadcrumb[]
}

export const Header: FC<HeaderProps> = ({ breadcrumbs }) => {
  return (
    <Stack
      direction="row"
      sx={{
        display: { xs: 'none', md: 'flex' },
        width: '100%',
        alignItems: { xs: 'flex-start', md: 'center' },
        justifyContent: 'space-between',
        maxWidth: { sm: '100%', md: '1700px' },
        pt: 1.5,
      }}
      spacing={2}
    >
      <NavbarBreadcrumbs items={breadcrumbs} />
      <Stack direction="row" sx={{ gap: 1 }}>
        <NotificationButton showBadge aria-label="Open notifications" />
        <ColorModeIconDropdown />
      </Stack>
    </Stack>
  )
}
