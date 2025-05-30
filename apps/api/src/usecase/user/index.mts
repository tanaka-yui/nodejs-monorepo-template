import type { CreateUserParams, IUserRepository, UpdateUserParams } from '~/domain/repository/userRepository.mjs'

export class UserUsecase {
  private readonly userRepository: IUserRepository

  constructor({ userRepository }: { userRepository: IUserRepository }) {
    this.userRepository = userRepository
    this.createUser = this.createUser.bind(this)
    this.updateUser = this.updateUser.bind(this)
    this.getUser = this.getUser.bind(this)
  }

  async createUser(user: CreateUserParams) {
    return this.userRepository.create(user)
  }

  async updateUser(user: UpdateUserParams) {
    return this.userRepository.update(user)
  }

  async getUser(id: string) {
    return this.userRepository.findById(id)
  }
}
