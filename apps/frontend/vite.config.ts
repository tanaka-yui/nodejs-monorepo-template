import * as path from 'node:path'
import { TanStackRouterVite } from '@tanstack/router-plugin/vite'
import react from '@vitejs/plugin-react-swc'
import visualizer from 'rollup-plugin-visualizer'
import { type UserConfig, defineConfig, loadEnv } from 'vite'
import { createHtmlPlugin } from 'vite-plugin-html'
import svgr from 'vite-plugin-svgr'
import tsconfigPaths from 'vite-tsconfig-paths'

const genCfg = (mode: string): UserConfig => {
  const envDir = path.join(__dirname, './envs')
  const env = loadEnv(mode, envDir, '')

  const cfg: UserConfig = {
    mode: mode === 'development' ? 'development' : 'production',
    envDir,
    publicDir: path.resolve(__dirname, './public'),
    plugins: [
      tsconfigPaths(),
      react(),
      svgr(),
      TanStackRouterVite(),
      createHtmlPlugin({
        inject: {
          data: {
            gtmId: String(env.VITE_GTM_ID ?? ''),
          },
        },
      }),
    ],
    build: {
      minify: mode !== 'development',
      sourcemap: env.VITE_SOURCE_MAP === 'true',
      chunkSizeWarningLimit: 1000,
      outDir: './dist',
      rollupOptions: {
        output: {
          manualChunks: {
            react: ['react', 'react-dom'],
          },
        },
        plugins: [
          /* @ts-ignore */
          mode === 'analyze' &&
            visualizer({
              open: true,
              filename: 'dist-dev/stats.html',
              gzipSize: true,
              brotliSize: true,
            }),
        ],
      },
    },
  }

  cfg.server = {
    host: '0.0.0.0',
    port: 8888,
    open: false,
    cors: true,
    proxy: {
      '^/api': {
        target: 'http://localhost:8889',
        changeOrigin: true,
        secure: true,
        xfwd: true,
        headers: {
          'X-Forwarded-Proto': 'http',
          'X-Forwarded-Host': 'localhost',
        },
        timeout: 5000,
        proxyTimeout: 5000,
      },
    },
  }

  return cfg
}

export default defineConfig(({ mode }) => {
  return genCfg(mode ?? 'development')
})
