import type { Prisma, PrismaClient } from '@prisma/client'
import { NotFoundError } from '~/core/errors.mjs'
import type { UserEntity } from '~/domain/entity/user.mjs'
import type { CreateUserParams, IUserRepository, UpdateUserParams } from '~/domain/repository/userRepository.mjs'

const toPrismaModel = (user: CreateUserParams): Prisma.UserCreateInput => {
  return {
    name: user.name,
  }
}

declare module '@prisma/client' {
  //PrismaClient
  interface PrismaClient {
    user: {
      paginate: (args: Prisma.UserFindManyArgs) => Promise<{ items: User[]; totalCount: number }>
    }
  }
}

export class UserRepository implements IUserRepository {
  private readonly prisma: PrismaClient

  constructor({ prismaClient }: { prismaClient: PrismaClient }) {
    this.prisma = prismaClient
    this.create = this.create.bind(this)
    this.findById = this.findById.bind(this)
  }

  async create(user: CreateUserParams) {
    return this.prisma.user.create({
      data: toPrismaModel(user),
    })
  }

  async update(user: UpdateUserParams) {
    return this.prisma.user.update({
      where: { id: user.id },
      data: toPrismaModel(user),
    })
  }

  async list() {
    return this.prisma.user.paginate({}).then((result) => {
      return result.items.map((item) => {
        return {
          id: item.id,
          name: item.name,
        }
      })
    })
  }

  async findById(id: string): Promise<UserEntity> {
    const result = await this.prisma.user.findFirst({
      where: { id },
    })
    if (!result) {
      throw new NotFoundError('User not found')
    }
    return {
      id: result.id,
      name: result.name,
    }
  }
}
