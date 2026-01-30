const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'solarease',
});

pool.query('SELECT id, first_name, email, role FROM users WHERE email = $1', ['ibrahim@gmail.com'], (err, result) => {
  if (err) {
    console.error('Error:', err);
  } else {
    console.log('User found:');
    console.log(JSON.stringify(result.rows, null, 2));
  }
  process.exit(0);
});
