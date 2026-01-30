const { Pool } = require('pg');
const bcrypt = require('bcrypt');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'solarease',
});

async function addRoleColumnAndAdmin() {
  try {
    // Add role column if it doesn't exist
    console.log('⏳ Adding role column to users table...');
    await pool.query(`
      ALTER TABLE users 
      ADD COLUMN IF NOT EXISTS role VARCHAR(50) DEFAULT 'user'
    `);
    console.log('✓ Role column added successfully');

    // Hash the admin password
    console.log('\n⏳ Hashing admin password...');
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash('admin123', saltRounds); // Using a stronger default password

    // Insert predefined admin user
    console.log('⏳ Inserting admin user...');
    const adminQuery = `
      INSERT INTO users (first_name, last_name, email, password, role)
      VALUES ($1, $2, $3, $4, $5)
      ON CONFLICT (email) DO UPDATE 
      SET role = 'admin', password = EXCLUDED.password
      RETURNING id, first_name, last_name, email, role, created_at
    `;
    
    const result = await pool.query(adminQuery, [
      'Admin',
      'User',
      'admin@solarease.com',
      hashedPassword,
      'admin'
    ]);

    console.log('\n✓✓✓ ADMIN USER SETUP COMPLETED ✓✓✓');
    console.log('Admin Details:');
    console.log('Email:', result.rows[0].email);
    console.log('First Name:', result.rows[0].first_name);
    console.log('Last Name:', result.rows[0].last_name);
    console.log('Role:', result.rows[0].role);
    console.log('Default Password: admin123 (Please change after first login)');
    console.log('=========================================\n');

    pool.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
    pool.end();
    process.exit(1);
  }
}

addRoleColumnAndAdmin();
