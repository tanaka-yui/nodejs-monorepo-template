import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import '~/assets/main.css'
import { RootProvider } from '~/providers'

const root = document.getElementById('root')

if (root) {
  createRoot(root).render(
    <StrictMode>
      <RootProvider />
    </StrictMode>,
  )
}
