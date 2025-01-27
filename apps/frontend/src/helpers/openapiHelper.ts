import { X_FROM } from '~/consts/httpHeaders'
import { Configuration } from '~/gen/api'

export const openapiConfig = new Configuration({
  basePath: import.meta.env.VITE_API_URL,
  headers: {
    [X_FROM]: `${location.protocol}//${location.hostname}`,
  },
})
