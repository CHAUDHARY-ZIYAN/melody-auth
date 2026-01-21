const dotenv = require('dotenv')
dotenv.config({ path: '.dev.vars' })

/**
 * @type { Object.<string, import("knex").Knex.Config> }
 */
module.exports = {
  client: process.env.DB_CLIENT === 'sqlite' ? 'better-sqlite3' : 'pg',
  connection: process.env.DB_CLIENT === 'sqlite'
    ? { filename: process.env.SQLITE_FILENAME || './dev.sqlite3' }
    : process.env.PG_CONNECTION_STRING,
  migrations: { directory: process.env.DB_CLIENT === 'sqlite' ? './migrations/sqlite' : './migrations/pg' },
  useNullAsDefault: true,
}
