import { useTranslation } from 'react-i18next'
import { setLocale } from 'yup'
import type { Message, LocaleObject as YupLocaleObject } from 'yup'

declare module 'yup' {
  export interface MixedLocale {
    default?: Message<Record<string, string>>
    required?: Message<Record<string, string>>
    oneOf?: Message<{
      values: string | string[]
    }>
    notOneOf?: Message<{
      values: string | string[]
    }>
    notNull?: Message<Record<string, string>>
    notType?: Message<Record<string, string>>
    defined?: Message<Record<string, string>>
  }

  interface StringLocale {
    length?: Message<{
      length: number
    }>
    min?: Message<{
      min: number
    }>
    max?: Message<{
      max: number
    }>
    matches?: Message<{
      regex: RegExp
    }>
    email?: Message<{
      regex: RegExp
    }>
    url?: Message<{
      regex: RegExp
    }>
    uuid?: Message<{
      regex: RegExp
    }>
    datetime?: Message<Record<string, string>>
    datetime_offset?: Message<Record<string, string>>
    datetime_precision?: Message<{
      precision: number
    }>
    trim?: Message<Record<string, string>>
    lowercase?: Message<Record<string, string>>
    uppercase?: Message<Record<string, string>>
  }
  interface NumberLocale {
    min?: Message<{
      min: number
    }>
    max?: Message<{
      max: number
    }>
    lessThan?: Message<{
      less: number
    }>
    moreThan?: Message<{
      more: number
    }>
    positive?: Message<{
      more: number
    }>
    negative?: Message<{
      less: number
    }>
    integer?: Message<Record<string, string>>
  }
  interface ObjectLocale {
    noUnknown?: Message<Record<string, string>>
  }
  interface BooleanLocale {
    isValue?: Message<Record<string, string>>
  }
  export interface LocaleObjectCustom extends YupLocaleObject {
    mixed?: MixedLocale
    string?: StringLocale
    number?: NumberLocale
    object?: ObjectLocale & {
      noUnknown?: Message<{ unknown: string[] }>
    }
    boolean?: BooleanLocale
  }

  export function setLocale(custom: LocaleObjectCustom): void
}

export const useInitializeLocal = (): void => {
  const { t } = useTranslation('validation')

  setLocale({
    mixed: {
      default: ({ label }) => t('mixed.default', { label }),
      required: ({ label }) => t('mixed.required', { label }),
      oneOf: ({ label, values }) => t('mixed.oneOf', { label, values }),
      notOneOf: ({ label, values }) => t('mixed.notOneOf', { label, values }),
      notNull: ({ label }) => t('mixed.notNull', { label }),
      notType: ({ label }) => t('mixed.notType', { label }),
      defined: ({ label }) => t('mixed.defined', { label }),
    },
    string: {
      length: ({ label, length }) => t('string.length', { label, length }),
      min: ({ label, min }) => t('string.min', { label, min }),
      max: ({ label, max }) => t('string.max', { label, max }),
      matches: ({ label, regex }) => t('string.matches', { label, regex }),
      email: ({ label }) => t('string.email', { label }),
      url: ({ label }) => t('string.url', { label }),
      uuid: ({ label }) => t('string.uuid', { label }),
      datetime: ({ label }) => t('string.datetime', { label }),
      datetime_offset: ({ label }) => t('string.datetime_offset', { label }),
      datetime_precision: ({ label }) => t('string.datetime_precision', { label }),
      trim: ({ label }) => t('string.trim', { label }),
      lowercase: ({ label }) => t('string.lowercase', { label }),
      uppercase: ({ label }) => t('string.uppercase', { label }),
    },
    number: {
      min: ({ label, min }) => t('number.min', { label, min }),
      max: ({ label, max }) => t('number.max', { label, max }),
      lessThan: ({ label, less }) => t('number.lessThan', { label, less }),
      moreThan: ({ label, more }) => t('number.moreThan', { label, more }),
      positive: ({ label }) => t('number.positive', { label }),
      negative: ({ label }) => t('number.negative', { label }),
      integer: ({ label }) => t('number.integer', { label }),
    },
    boolean: {
      isValue: ({ label }) => t('boolean.isValue', { label }),
    },
    date: {
      min: ({ label, min }) => t('date.min', { label, min }),
      max: ({ label, max }) => t('date.max', { label, max }),
    },
    object: {
      noUnknown: ({ label }: { label: string }) => t('object.noUnknown', { label }),
    },
    array: {
      min: ({ label, min }: { label: string; min: number }) => t('array.min', { label, min }),
      max: ({ label, max }: { label: string; max: number }) => t('array.max', { label, max }),
    },
  })
}
