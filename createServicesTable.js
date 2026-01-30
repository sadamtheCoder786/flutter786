const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  password: 'osama123',
  host: 'localhost',
  port: 5432,
  database: 'solarease',
});

// Create services table
const createTableQuery = `
  CREATE TABLE IF NOT EXISTS services (
    id SERIAL PRIMARY KEY,
    service_guy_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_name VARCHAR(255) NOT NULL,
    service_type VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
`;

pool.query(createTableQuery, (err, result) => {
  if (err) {
    console.error('❌ Error creating services table:', err.message);
  } else {
    console.log('✓ Services table created successfully!');
    console.log('Table schema: id, service_guy_id, service_name, service_type, price, description, created_at, updated_at');
  }
  process.exit(0);
});
