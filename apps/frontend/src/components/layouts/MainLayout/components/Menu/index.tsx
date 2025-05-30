import List from '@mui/material/List'
import ListItem from '@mui/material/ListItem'
import ListItemButton from '@mui/material/ListItemButton'
import ListItemIcon from '@mui/material/ListItemIcon'
import ListItemText from '@mui/material/ListItemText'
import Stack from '@mui/material/Stack'
import { Link, useMatchRoute } from '@tanstack/react-router'
import type { FC, ReactNode } from 'react'

export type MenuItem = {
  text: string
  icon: ReactNode
  path: string
}

export type MenuProps = {
  items: MenuItem[]
}

export const Menu: FC<MenuProps> = ({ items }) => {
  const matchRoute = useMatchRoute()

  return (
    <Stack sx={{ flexGrow: 1, p: 1, justifyContent: 'space-between' }}>
      <List>
        {items.map((item) => (
          <ListItem key={item.text} disablePadding sx={{ display: 'block' }}>
            <ListItemButton
              component={Link}
              to={item.path}
              selected={
                !!matchRoute({
                  to: item.path,
                  fuzzy: true,
                })
              }
            >
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
    </Stack>
  )
}
