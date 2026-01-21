const fs = require('fs')
const path = require('path')
const Database = require('better-sqlite3')

const dbPath = path.join(
  __dirname,
  '../../dev.sqlite3',
)
const migrationsDir = path.join(
  __dirname,
  '../../migrations/sqlite',
)

const db = new Database(dbPath)

const files = fs.readdirSync(migrationsDir).sort()

for (const file of files) {
  if (file.endsWith('.sql')) {
    console.log(`Applying ${file}...`)
    const sql = fs.readFileSync(
      path.join(
        migrationsDir,
        file,
      ),
      'utf8',
    )
    try {
      db.exec(sql)
    } catch (e) {
      console.error(
        `Failed to apply ${file}:`,
        e.message,
      )
      // Continue or exit? D1 migrations usually stop on failure.
      // But some might fail if "already exists" and we are re-running.
      // Since we deleted the DB, it should be fine.
      process.exit(1)
    }
  }
}

console.log('Migrations applied successfully.')
