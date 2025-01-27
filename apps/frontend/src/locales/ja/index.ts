import translation from './translation.json'
import validation from './validation.json'

export type I18nNamespaces = {
  translation: typeof translation
  validation: typeof validation
}

export const defaultNS = 'translation'

declare module 'i18next' {
  interface CustomTypeOptions {
    resources: I18nNamespaces
    defaultNS: typeof defaultNS
  }
}

export default {
  translation,
  validation,
}
