import {
  addMonths,
  endOfDay as dfEndOfDay,
  endOfMonth as dfEndOfMonth,
  endOfYear as dfEndOfYear,
  formatRFC3339 as dfFormatRFC3339,
  startOfDay as dfStartOfDay,
  startOfMonth as dfStartOfMonth,
  startOfYear as dfStartOfYear,
  formatDate,
  isValid,
  parseISO,
} from 'date-fns'

export enum DateFormat {
  DATE = 'yyyy-MM-dd',
  DATE_TIME_HOUR = 'yyyy-MM-dd HH',
  DATE_TIME_MINUTE = 'yyyy-MM-dd HH:mm',
  DATE_TIME_MINUTE_SLASH = 'yyyy/MM/dd HH:mm',
  DATE_TIME = 'yyyy-MM-dd HH:mm:ss',
  DATE_TIME_SLASH = 'yyyy/MM/dd HH:mm:ss',
  DATE_SLASH = 'yyyy/MM/dd',
  DATE_JA = 'yyyy年MM月dd日',
  DATE_JA_SLASH = 'yyyy/MM/dd(ddd)',
  DATE_TIME_JA = 'yyyy年MM月dd日(ddd) HH:mm',
  DATE_TIME_JA_SLASH = 'yyyy/MM/dd/(ddd) HH:mm',
  TIME = 'HH:mm:ss.SSSZ',
  MINUTES = 'mm:ss.SSSZ',
  HOUR_MINUTE = 'HH:mm',
  YEAR = 'yyyy',
  YEAR_JA = 'yyyy年',
  MONTH = 'MM',
  MONTH_JA = 'MM月',
  DAY = 'dd',
  DAY_JA = 'dd日',
  MONTH_DAY_SLASH = 'MM/dd',
  MONTH_DAY_TIME_JA = 'M月D日（ddd） HH:mm',
  YEAR_MONTH = 'yyyy-MM',
  YEAR_MONTH_SLASH = 'yyyy/MM',
  YEAR_MONTH_JA = 'yyyy年M月',
  RFC3339 = "yyyy-MM-dd'T'HH:mm:ss.SSSX",
}

export const parseDate = (dateString: string): Date | undefined => {
  const date = parseISO(dateString)
  if (!isValid(date)) {
    return undefined
  }
  return date
}

export const formatRFC3339 = (date: Date): string => {
  return dfFormatRFC3339(date)
}

export const formatDatetime = (date: Date | string, reFormat: DateFormat): string => {
  const _date = typeof date === 'string' ? parseDate(date) : date
  if (_date == null) {
    return 'invalid date'
  }

  return formatDate(_date, reFormat)
}

export const startOfYear = (date: Date): Date => dfStartOfYear(date)

export const startOfMonth = (date: Date): Date => dfStartOfMonth(date)

export const startOfDay = (date: Date): Date => dfStartOfDay(date)

export const endOfYear = (date: Date): Date => dfEndOfYear(date)

export const endOfMonth = (date: Date): Date => dfEndOfMonth(date)

export const endOfDay = (date: Date): Date => dfEndOfDay(date)

export const addMonth = (date: Date, month: number): Date => addMonths(date, month)
