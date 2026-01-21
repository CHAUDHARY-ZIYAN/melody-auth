const path = require('path')
const Database = require('better-sqlite3')

const dbPath = path.join(
  __dirname,
  '../../dev.sqlite3',
)
const db = new Database(dbPath)

const row = db.prepare('SELECT * FROM app WHERE clientId = ?').get('2D2e4b4FDA6D41B006CB2832d9a37962CBD6D842BF85175cFCdcd88Db72B692f')
console.log(row)
