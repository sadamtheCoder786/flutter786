const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  password: 'osama123',
  host: 'localhost',
  port: 5432,
  database: 'solarease',
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
