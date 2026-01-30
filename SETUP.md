# Quick Setup Guide - SolarEase

## Prerequisites
- Node.js v14+ installed
- PostgreSQL v12+ installed and running
- Flutter SDK 3.9.2+ installed

## Backend Setup (5 minutes)

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment
Create a `.env` file in the `backend` directory:
```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```env
DB_USER=postgres
DB_PASSWORD=your_password_here
DB_HOST=localhost
DB_PORT=5432
DB_NAME=solarease
PORT=3000
```

### 3. Initialize Database
```bash
# Create database and users table
node setup.js

# Create products table
node createProductsTable.js

# Create services table
node createServicesTable.js

# Add role column and admin user
node addRoleColumn.js
```

### 4. Start Backend Server
```bash
npm start
```

Server will be available at `http://localhost:3000`

**Default Admin Credentials:**
- Email: `admin@solarease.com`
- Password: `admin123`
- ⚠️ **Change this password immediately after first login!**

## Frontend Setup (2 minutes)

### 1. Install Flutter Dependencies
```bash
# From project root
flutter pub get
```

### 2. Run the App
```bash
# For web
flutter run -d chrome

# For mobile (with device/emulator connected)
flutter run

# For all available devices
flutter devices
flutter run -d <device-id>
```

## Testing the Application

### Test Backend API
```bash
# Health check
curl http://localhost:3000

# Test signup (should return success)
curl -X POST http://localhost:3000/signup \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "email": "test@example.com",
    "password": "password123",
    "role": "customer"
  }'

# Test login
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## Common Issues

### Backend Won't Start
- **Error**: "Database connection failed"
  - Solution: Check PostgreSQL is running and credentials in `.env` are correct
  
- **Error**: "Port 3000 already in use"
  - Solution: Change PORT in `.env` or kill the process using port 3000

### Database Errors
- **Error**: "Database 'solarease' does not exist"
  - Solution: Run `node setup.js` to create the database

- **Error**: "Table does not exist"
  - Solution: Run the table creation scripts in order

### Flutter Errors
- **Error**: "Packages not found"
  - Solution: Run `flutter pub get`

- **Error**: "Cannot connect to backend"
  - Solution: Update API endpoint in Flutter code if backend is not on localhost:3000

## Project Structure
```
solarease/
├── backend/              # Node.js backend
│   ├── .env             # Environment variables (create this)
│   ├── .env.example     # Template
│   ├── server.js        # Main server
│   └── *.js             # Setup scripts
├── lib/                 # Flutter app code
│   ├── helpers/        # Utilities
│   ├── views/          # UI screens
│   └── main.dart       # Entry point
└── README.md           # Full documentation
```

## Next Steps

1. ✅ Backend running on port 3000
2. ✅ Database created and tables initialized
3. ✅ Flutter app connected to backend
4. 🔄 Change default admin password
5. 🔄 Start developing your features!

## Security Checklist

- [ ] Changed default admin password
- [ ] `.env` file is not committed to git
- [ ] Database uses a strong password
- [ ] Backend is secured (HTTPS in production)
- [ ] Regular dependency updates scheduled

## Need Help?

Check the main [README.md](README.md) for detailed documentation and API reference.

For security-related questions, see [SECURITY_SUMMARY.md](SECURITY_SUMMARY.md).
