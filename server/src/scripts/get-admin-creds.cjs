const Database = require('better-sqlite3');
const db = new Database('dev.sqlite3');

const spaApp = db.prepare("SELECT * FROM app WHERE name = 'Admin Panel (SPA)'").get();
const s2sApp = db.prepare("SELECT * FROM app WHERE name = 'Admin Panel (S2S)'").get();

console.log('SPA Client ID:', spaApp.clientId);
console.log('S2S Client ID:', s2sApp.clientId);
console.log('S2S Client Secret:', s2sApp.secret);
