import { useCallback } from 'react'

export const useAccessToken: () => {
  getAccessToken: () => Promise<string>
} = () => {
  const getAccessToken = useCallback(async (): Promise<string> => {
    // TODO: Implement this function
    return ''
  }, [])

  return {
    getAccessToken,
  }
}
