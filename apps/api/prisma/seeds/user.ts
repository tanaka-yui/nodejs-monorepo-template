import { faker } from '@faker-js/faker'
import type { PrismaClient } from '@prisma/client'

export const initUser = async (prisma: PrismaClient) => {
  await prisma.user.create({
    data: {
      name: faker.person.fullName(),
    },
  })
}
