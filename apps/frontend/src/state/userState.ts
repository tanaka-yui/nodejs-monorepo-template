import { atom, useAtom } from 'jotai'

type UserState = {
  name: string
  email: string
}

const userStateAtom = atom<UserState>({
  name: '',
  email: '',
})

export const useUserState = () => {
  const [userState, setUserState] = useAtom(userStateAtom)

  const setUserInfo = ({ name, email }: { name: string; email: string }) => {
    setUserState((prev) => ({ ...prev, name, email }))
  }

  return { userState, setUserInfo }
}
