import type { UserEntity } from '~/domain/entity/user.mjs'

export type CreateUserParams = {
  name: string
}

export type UpdateUserParams = {
  id: string
  name: string
}

export interface IUserRepository {
  create: (user: CreateUserParams) => Promise<UserEntity>
  update: (user: UpdateUserParams) => Promise<UserEntity>
  findById: (id: string) => Promise<UserEntity | null>
}
