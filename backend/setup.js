const { Client } = require('pg');

const client = new Client({
  user: 'postgres',      // Change to your username
  password: 'osama123',  // Change to your password
  host: 'localhost',
  port: 5432,
  database: 'postgres', // Connect to default postgres database first
});

client.connect(async (err) => {
  if (err) {
    console.error('Connection error:', err.stack);
    process.exit(1);
  }

  try {
    // Create database if it doesn't exist
    await client.query('CREATE DATABASE solarease');
    console.log('✓ Database "solarease" created successfully!');
  } catch (error) {
    if (error.code === '42P04') {
      console.log('✓ Database "solarease" already exists');
    } else {
      console.error('Error creating database:', error);
      client.end();
      process.exit(1);
    }
  }

  // Now connect to the solarease database
  client.end();
  
  const solarClient = new Client({
    user: 'postgres',
    password: 'osama123',
    host: 'localhost',
    port: 5432,
    database: 'solarease',
  });

  solarClient.connect(async (err) => {
    if (err) {
      console.error('Connection error:', err.stack);
      process.exit(1);
    }

    try {
      // Create users table
      const createTableQuery = `
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          first_name VARCHAR(100) NOT NULL,
          last_name VARCHAR(100) NOT NULL,
          email VARCHAR(255) UNIQUE NOT NULL,
          password VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      `;

      await solarClient.query(createTableQuery);
      console.log('✓ Users table created successfully!');

      solarClient.end();
    } catch (error) {
      console.error('Error creating table:', error);
      solarClient.end();
      process.exit(1);
    }
  });
});
