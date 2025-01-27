import NotificationsRoundedIcon from '@mui/icons-material/NotificationsRounded'
import Badge, { badgeClasses } from '@mui/material/Badge'
import IconButton, { type IconButtonProps } from '@mui/material/IconButton'
import type { FC } from 'react'

type MenuButtonProps = IconButtonProps & {
  showBadge?: boolean
}

export const NotificationButton: FC<MenuButtonProps> = ({ showBadge = false, ...props }) => {
  return (
    <Badge
      color="error"
      variant="dot"
      invisible={!showBadge}
      sx={{ [`& .${badgeClasses.badge}`]: { right: 2, top: 2 } }}
    >
      <IconButton size="small" {...props}>
        <NotificationsRoundedIcon />
      </IconButton>
    </Badge>
  )
}
