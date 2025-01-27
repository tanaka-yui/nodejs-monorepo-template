import { targets as external } from '~/infra/external/index.mjs'
import { targets as persistence } from '~/infra/persistence/index.mjs'

export const targets = [...external, ...persistence]
