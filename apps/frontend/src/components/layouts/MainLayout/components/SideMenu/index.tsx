import MuiDrawer, { drawerClasses } from '@mui/material/Drawer'
import { styled } from '@mui/material/styles'
import type { FC } from 'react'
import { Menu, type MenuItem } from '~/components/layouts/MainLayout/components/Menu'

const drawerWidth = 280

const Drawer = styled(MuiDrawer)({
  width: drawerWidth,
  flexShrink: 0,
  boxSizing: 'border-box',
  mt: 10,
  [`& .${drawerClasses.paper}`]: {
    width: drawerWidth,
    boxSizing: 'border-box',
  },
})

type SideMenuProps = {
  items: MenuItem[]
}

export const SideMenu: FC<SideMenuProps> = ({ items }) => {
  return (
    <Drawer
      variant="permanent"
      sx={{
        display: { xs: 'block', md: 'flex' },
        [`& .${drawerClasses.paper}`]: {
          backgroundColor: 'background.paper',
        },
        flexDirection: 'column',
        justifyContent: 'space-between',
        height: '100%',
      }}
    >
      <Menu items={items} />
    </Drawer>
  )
}
