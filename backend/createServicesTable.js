const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'solarease',
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
