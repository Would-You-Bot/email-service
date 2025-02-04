import { prisma } from "../helpers/prisma"

const time = 15 // time in minutes

export async function deleteUnconfirmedUsers() {
  const olderThan = new Date(Date.now() - time * 60 * 1000)
    console.log(`Deleting entries not verified within ${time} minutes.`)
  try {
    await prisma.waitlist.deleteMany({
      where: {
        isVerified: false,
        createdAt: {
          lt: olderThan
        }
      }
    })
  } catch (error) {
    throw new Error(
      `Error deleting unconfirmed users: ${JSON.stringify(error, null, 2)}`
    )
  }
}
