import knex from 'knex'

export let _db: knex.Knex | null = null

export const initConnection = () => {
  _db = knex({
    client: 'better-sqlite3',
    connection: { filename: process.env.SQLITE_FILENAME || './dev.sqlite3' },
    useNullAsDefault: true,
  })
}

export const getConnection = (): knex.Knex => {
  if (!_db) initConnection()
  return _db!
}

const convertQuery = (
  query: string, params: string[],
) => {
  let prepareQuery = query
  for (let i = 0; i < params.length; i++) {
    prepareQuery = prepareQuery.replace(
      `$${i + 1}`,
      '?',
    )
  }
  return prepareQuery
}

export const fit = (currentDb?: knex.Knex) => ({
  prepare: (query: string) => ({
    bind: (...params: string[]) => ({
      all: async () => {
        const prepareQuery = convertQuery(
          query,
          params,
        )
        const db = currentDb ?? getConnection()
        const results = await db.raw(
          prepareQuery,
          params,
        )
        return { results }
      },
      first: async () => {
        const prepareQuery = convertQuery(
          query,
          params,
        )
        const db = currentDb ?? getConnection()
        const result = await db.raw(
          `${prepareQuery} limit 1`,
          params,
        )
        return result[0]
      },
      run: async () => {
        const prepareQuery = convertQuery(
          query,
          params,
        )
        const db = currentDb ?? getConnection()
        // Try without returning first to see if it works
        const result = await db.raw(
          prepareQuery,
          params,
        )

        // better-sqlite3 returns RunResult with lastInsertRowid
        return {
          success: true,
          meta: { last_row_id: result.lastInsertRowid },
        }
      },
    }),
    all: async () => {
      const db = currentDb ?? getConnection()
      const results = await db.raw(query)
      return { results }
    },
    first: async () => {
      const db = currentDb ?? getConnection()
      const result = await db.raw(`${query} limit 1`)
      return result[0]
    },
  }),
})
