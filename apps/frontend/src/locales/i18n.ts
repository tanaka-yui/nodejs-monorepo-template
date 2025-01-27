import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

import ja from '~/locales/ja'

export const DEFAULT_LANGUAGE = 'ja'

export const LANGUAGE_STORE_KEY = 'by_current_lang'

const resources = {
  ja,
}

const lng = localStorage.getItem(LANGUAGE_STORE_KEY) ?? DEFAULT_LANGUAGE

void i18n
  .use(initReactI18next) // passes i18n down to react-i18next
  .init({
    resources,
    fallbackLng: lng,
    debug: import.meta.env.VITE_DEBUG === 'true',
    interpolation: {
      escapeValue: false, // react already safes from xss
    },
  })

export default i18n
