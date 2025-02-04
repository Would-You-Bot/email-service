import cron from 'node-cron'
import { deleteUnconfirmedUsers } from './tasks/deleteUnconfirmedEmails'
import { EVERY_MINUTE } from './utils/cron'

export const deleteUnconfirmedCronJob = cron.schedule(
  EVERY_MINUTE,
  deleteUnconfirmedUsers
)
