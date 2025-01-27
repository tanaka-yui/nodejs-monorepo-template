import NavigateNextRoundedIcon from '@mui/icons-material/NavigateNextRounded'
import Breadcrumbs, { breadcrumbsClasses } from '@mui/material/Breadcrumbs'
import Typography from '@mui/material/Typography'
import { styled } from '@mui/material/styles'
import { Link } from '@tanstack/react-router'
import type { FC } from 'react'

const StyledBreadcrumbs = styled(Breadcrumbs)(({ theme }) => ({
  margin: theme.spacing(1, 0),
  [`& .${breadcrumbsClasses.separator}`]: {
    color: theme.palette.action.disabled,
    margin: 1,
  },
  [`& .${breadcrumbsClasses.ol}`]: {
    alignItems: 'center',
  },
}))

export type Breadcrumb = {
  label: string
  to?: string
  bold?: boolean
}

type NavbarBreadcrumbsProps = {
  items: Breadcrumb[]
}

export const NavbarBreadcrumbs: FC<NavbarBreadcrumbsProps> = ({ items }) => {
  return (
    <StyledBreadcrumbs aria-label="breadcrumb" separator={<NavigateNextRoundedIcon fontSize="small" />}>
      {items.map((item) => {
        if (item.to) {
          return (
            <Link key={item.label} to={item.to}>
              {item.label}
            </Link>
          )
        }
        return (
          <Typography key={item.label} sx={{ color: 'text.primary', fontWeight: item?.bold ? 600 : 400 }}>
            {item.label}
          </Typography>
        )
      })}
    </StyledBreadcrumbs>
  )
}
