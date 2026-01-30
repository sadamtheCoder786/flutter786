const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(express.json()); // VERY IMPORTANT

const PORT = 3000;

// PostgreSQL Connection Pool
const pool = new Pool({
  user: 'postgres',      // Change to your username
  password: 'osama123',  // Change to your password
  host: 'localhost',
  port: 5432,
  database: 'solarease',
});

// Test the connection
pool.query('SELECT NOW()', (err, result) => {
  if (err) {
    console.error('❌ Database connection failed:', err.message);
  } else {
    console.log('✓ Connected to PostgreSQL database: solarease');
    console.log('✓ Database server time:', result.rows[0].now);
  }
});

pool.on('error', (err) => {
  console.error('Pool connection error:', err.stack);
});

// Health check
app.get('/', (req, res) => {
  res.send('Backend is running');
});

// SIGNUP API
app.post('/signup', async (req, res) => {
  const { firstName, lastName, email, password, role } = req.body;
  
  const userRole = role || 'customer'; // Default to 'customer' if not provided
  
  console.log('\n========== SIGNUP REQUEST RECEIVED ==========');
  console.log('First Name:', firstName);
  console.log('Last Name :', lastName);
  console.log('Email     :', email);
  console.log('Password  :', password);
  console.log('Role      :', userRole);
  console.log('==========================================');
  
  // Validate inputs
  if (!firstName || !lastName || !email || !password) {
    console.error('❌ Missing required fields');
    return res.status(400).json({ message: 'Missing required fields' });
  }
  
  try {
    console.log('⏳ Inserting user into database...');
    // Insert user into database with the selected role
    const query = 'INSERT INTO users (first_name, last_name, email, password, role) VALUES ($1, $2, $3, $4, $5) RETURNING *';
    const result = await pool.query(query, [firstName, lastName, email, password, userRole]);
    
    console.log('\n✓✓✓ USER SAVED SUCCESSFULLY! ✓✓✓');
    console.log('User ID:', result.rows[0].id);
    console.log('User data:', result.rows[0]);
    console.log('Role:', userRole);
    console.log('Database: solarease');
    console.log('Table: users');
    console.log('=========================================\n');
    
    res.status(201).json({ message: 'User registered successfully', user: result.rows[0] });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('Error code:', error.code);
    console.error('Full error:', error);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error registering user', error: error.message });
  }
});

// LOGIN API
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  
  console.log('\n========== LOGIN REQUEST RECEIVED ==========');
  console.log('Email     :', email);
  console.log('Password  :', password);
  console.log('=========================================');
  
  // Validate inputs
  if (!email || !password) {
    console.error('❌ Missing email or password');
    return res.status(400).json({ message: 'Missing email or password' });
  }

  try {
    console.log('⏳ Querying database for user...');
    // Query database for user
    const query = 'SELECT * FROM users WHERE email = $1 AND password = $2';
    const result = await pool.query(query, [email, password]);
    
    if (result.rows.length > 0) {
      console.log('\n✓✓✓ LOGIN SUCCESSFUL ✓✓✓');
      console.log('User ID:', result.rows[0].id);
      console.log('User Name:', result.rows[0].first_name, result.rows[0].last_name);
      console.log('Email:', result.rows[0].email);
      console.log('Role:', result.rows[0].role);
      console.log('=========================================\n');
      res.status(200).json({ message: 'Login successful', user: result.rows[0] });
    } else {
      console.log('❌ Login Status: FAILED - Invalid credentials');
      console.log('=========================================\n');
      res.status(401).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    console.error('❌ DATABASE ERROR');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error during login', error: error.message });
  }
});

// ADD PRODUCT API
app.post('/addProduct', async (req, res) => {
  const { shopownerId, productName, price, description } = req.body;

  console.log('\n========== ADD PRODUCT REQUEST ==========');
  console.log('Shopowner ID:', shopownerId);
  console.log('Product Name:', productName);
  console.log('Price:', price);
  console.log('Description:', description);
  console.log('=========================================');

  if (!shopownerId || !productName || !price) {
    console.error('❌ Missing required fields');
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    console.log('⏳ Inserting product into database...');
    const query = 'INSERT INTO products (shopowner_id, product_name, price, description) VALUES ($1, $2, $3, $4) RETURNING *';
    const result = await pool.query(query, [shopownerId, productName, price, description]);

    console.log('\n✓✓✓ PRODUCT ADDED SUCCESSFULLY! ✓✓✓');
    console.log('Product ID:', result.rows[0].id);
    console.log('Product Data:', result.rows[0]);
    console.log('=========================================\n');

    res.status(201).json({ message: 'Product added successfully', product: result.rows[0] });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error adding product', error: error.message });
  }
});

// GET PRODUCTS API
app.get('/getProducts/:shopownerId', async (req, res) => {
  const { shopownerId } = req.params;

  console.log('\n========== GET PRODUCTS REQUEST ==========');
  console.log('Shopowner ID:', shopownerId);
  console.log('=========================================');

  try {
    console.log('⏳ Fetching products from database...');
    const query = 'SELECT * FROM products WHERE shopowner_id = $1 ORDER BY created_at DESC';
    const result = await pool.query(query, [shopownerId]);

    console.log('\n✓ Products fetched successfully!');
    console.log('Total products:', result.rows.length);
    console.log('=========================================\n');

    res.status(200).json({ message: 'Products fetched successfully', products: result.rows });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error fetching products', error: error.message });
  }
});

// DELETE PRODUCT API
app.delete('/deleteProduct/:productId', async (req, res) => {
  const { productId } = req.params;

  console.log('\n========== DELETE PRODUCT REQUEST ==========');
  console.log('Product ID:', productId);
  console.log('=========================================');

  try {
    console.log('⏳ Deleting product from database...');
    const query = 'DELETE FROM products WHERE id = $1 RETURNING *';
    const result = await pool.query(query, [productId]);

    if (result.rows.length > 0) {
      console.log('\n✓ Product deleted successfully!');
      console.log('Deleted Product:', result.rows[0]);
      console.log('=========================================\n');
      res.status(200).json({ message: 'Product deleted successfully', product: result.rows[0] });
    } else {
      console.log('❌ Product not found');
      res.status(404).json({ message: 'Product not found' });
    }
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error deleting product', error: error.message });
  }
});

// UPDATE PRODUCT API
app.put('/updateProduct/:productId', async (req, res) => {
  const { productId } = req.params;
  const { productName, price, description } = req.body;

  console.log('\n========== UPDATE PRODUCT REQUEST ==========');
  console.log('Product ID:', productId);
  console.log('Product Name:', productName);
  console.log('Price:', price);
  console.log('Description:', description);
  console.log('=========================================');

  if (!productName || !price) {
    console.error('❌ Missing required fields');
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    console.log('⏳ Updating product in database...');
    const query = 'UPDATE products SET product_name = $1, price = $2, description = $3, updated_at = CURRENT_TIMESTAMP WHERE id = $4 RETURNING *';
    const result = await pool.query(query, [productName, price, description, productId]);

    if (result.rows.length > 0) {
      console.log('\n✓✓✓ PRODUCT UPDATED SUCCESSFULLY! ✓✓✓');
      console.log('Updated Product:', result.rows[0]);
      console.log('=========================================\n');
      res.status(200).json({ message: 'Product updated successfully', product: result.rows[0] });
    } else {
      console.log('❌ Product not found');
      res.status(404).json({ message: 'Product not found' });
    }
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error updating product', error: error.message });
  }
});

// ============ SERVICE APIS ============

// ADD SERVICE API
app.post('/addService', async (req, res) => {
  const { serviceGuyId, serviceName, serviceType, price, description } = req.body;

  console.log('\n========== ADD SERVICE REQUEST ==========');
  console.log('Service Guy ID:', serviceGuyId);
  console.log('Service Name:', serviceName);
  console.log('Service Type:', serviceType);
  console.log('Price:', price);
  console.log('Description:', description);
  console.log('=========================================');

  if (!serviceGuyId || !serviceName || !serviceType || !price) {
    console.error('❌ Missing required fields');
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    console.log('⏳ Inserting service into database...');
    const query = 'INSERT INTO services (service_guy_id, service_name, service_type, price, description) VALUES ($1, $2, $3, $4, $5) RETURNING *';
    const result = await pool.query(query, [serviceGuyId, serviceName, serviceType, price, description]);

    console.log('\n✓✓✓ SERVICE ADDED SUCCESSFULLY! ✓✓✓');
    console.log('Service ID:', result.rows[0].id);
    console.log('Service Data:', result.rows[0]);
    console.log('=========================================\n');

    res.status(201).json({ message: 'Service added successfully', service: result.rows[0] });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error adding service', error: error.message });
  }
});

// GET SERVICES API
app.get('/getServices/:serviceGuyId', async (req, res) => {
  const { serviceGuyId } = req.params;

  console.log('\n========== GET SERVICES REQUEST ==========');
  console.log('Service Guy ID:', serviceGuyId);
  console.log('=========================================');

  try {
    console.log('⏳ Fetching services from database...');
    const query = 'SELECT * FROM services WHERE service_guy_id = $1 ORDER BY created_at DESC';
    const result = await pool.query(query, [serviceGuyId]);

    console.log('\n✓ Services fetched successfully!');
    console.log('Total services:', result.rows.length);
    console.log('=========================================\n');

    res.status(200).json({ message: 'Services fetched successfully', services: result.rows });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error fetching services', error: error.message });
  }
});

// DELETE SERVICE API
app.delete('/deleteService/:serviceId', async (req, res) => {
  const { serviceId } = req.params;

  console.log('\n========== DELETE SERVICE REQUEST ==========');
  console.log('Service ID:', serviceId);
  console.log('=========================================');

  try {
    console.log('⏳ Deleting service from database...');
    const query = 'DELETE FROM services WHERE id = $1 RETURNING *';
    const result = await pool.query(query, [serviceId]);

    if (result.rows.length > 0) {
      console.log('\n✓ Service deleted successfully!');
      console.log('Deleted Service:', result.rows[0]);
      console.log('=========================================\n');
      res.status(200).json({ message: 'Service deleted successfully', service: result.rows[0] });
    } else {
      console.log('❌ Service not found');
      res.status(404).json({ message: 'Service not found' });
    }
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error deleting service', error: error.message });
  }
});

// UPDATE SERVICE API
app.put('/updateService/:serviceId', async (req, res) => {
  const { serviceId } = req.params;
  const { serviceName, serviceType, price, description } = req.body;

  console.log('\n========== UPDATE SERVICE REQUEST ==========');
  console.log('Service ID:', serviceId);
  console.log('Service Name:', serviceName);
  console.log('Service Type:', serviceType);
  console.log('Price:', price);
  console.log('Description:', description);
  console.log('=========================================');

  if (!serviceName || !serviceType || !price) {
    console.error('❌ Missing required fields');
    return res.status(400).json({ message: 'Missing required fields' });
  }

  try {
    console.log('⏳ Updating service in database...');
    const query = 'UPDATE services SET service_name = $1, service_type = $2, price = $3, description = $4, updated_at = CURRENT_TIMESTAMP WHERE id = $5 RETURNING *';
    const result = await pool.query(query, [serviceName, serviceType, price, description, serviceId]);

    if (result.rows.length > 0) {
      console.log('\n✓✓✓ SERVICE UPDATED SUCCESSFULLY! ✓✓✓');
      console.log('Updated Service:', result.rows[0]);
      console.log('=========================================\n');
      res.status(200).json({ message: 'Service updated successfully', service: result.rows[0] });
    } else {
      console.log('❌ Service not found');
      res.status(404).json({ message: 'Service not found' });
    }
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error updating service', error: error.message });
  }
});

// ============ GET ALL PRODUCTS (For Customers) ============
app.get('/getAllProducts', async (req, res) => {
  console.log('\n========== GET ALL PRODUCTS REQUEST ==========');

  try {
    console.log('⏳ Fetching all products from database...');
    const query = 'SELECT p.*, u.first_name as shopowner_name FROM products p JOIN users u ON p.shopowner_id = u.id ORDER BY p.created_at DESC';
    const result = await pool.query(query);

    console.log('\n✓ All products fetched successfully!');
    console.log('Total products:', result.rows.length);
    console.log('=========================================\n');

    res.status(200).json({ message: 'All products fetched successfully', products: result.rows });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error fetching products', error: error.message });
  }
});

// ============ GET ALL SERVICES (For Customers) ============
app.get('/getAllServices', async (req, res) => {
  console.log('\n========== GET ALL SERVICES REQUEST ==========');

  try {
    console.log('⏳ Fetching all services from database...');
    const query = 'SELECT s.*, u.first_name as service_guy_name FROM services s JOIN users u ON s.service_guy_id = u.id ORDER BY s.created_at DESC';
    const result = await pool.query(query);

    console.log('\n✓ All services fetched successfully!');
    console.log('Total services:', result.rows.length);
    console.log('=========================================\n');

    res.status(200).json({ message: 'All services fetched successfully', services: result.rows });
  } catch (error) {
    console.error('\n❌ DATABASE ERROR ❌');
    console.error('Error message:', error.message);
    console.error('=========================================\n');
    res.status(500).json({ message: 'Error fetching services', error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
