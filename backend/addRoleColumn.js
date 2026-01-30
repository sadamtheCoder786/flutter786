const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  password: 'osama123',
  host: 'localhost',
  port: 5432,
  database: 'solarease',
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

    // Insert predefined admin user
    console.log('\n⏳ Inserting admin user...');
    const adminQuery = `
      INSERT INTO users (first_name, last_name, email, password, role)
      VALUES ($1, $2, $3, $4, $5)
      ON CONFLICT (email) DO UPDATE 
      SET role = 'admin'
      RETURNING *
    `;
    
    const result = await pool.query(adminQuery, [
      'osama',
      'khan',
      'test@gmail.com',
      'test1234',
      'admin'
    ]);

    console.log('\n✓✓✓ ADMIN USER SETUP COMPLETED ✓✓✓');
    console.log('Admin Details:');
    console.log('Email:', result.rows[0].email);
    console.log('First Name:', result.rows[0].first_name);
    console.log('Last Name:', result.rows[0].last_name);
    console.log('Role:', result.rows[0].role);
    console.log('=========================================\n');

    pool.end();
  } catch (error) {
    console.error('❌ Error:', error.message);
    pool.end();
    process.exit(1);
  }
}

addRoleColumnAndAdmin();
