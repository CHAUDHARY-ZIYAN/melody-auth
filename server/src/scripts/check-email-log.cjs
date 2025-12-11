const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '../../dev.sqlite3');
const db = new Database(dbPath);

try {
    const row = db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='email_log'").get();
    console.log('Table exists:', row);

    if (row) {
        const columns = db.prepare("PRAGMA table_info(email_log)").all();
        console.log('Columns:', columns);
    }
} catch (e) {
    console.error(e);
}
