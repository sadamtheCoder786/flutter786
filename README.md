# SolarEase - Solar Energy Management Application

A comprehensive Flutter application for adopting and managing solar energy solutions.

## Overview

SolarEase is a mobile application built with Flutter that helps users manage solar products and services. The application includes features for customers, shop owners, and service providers.

## Features

- User authentication (signup/login) with role-based access
- Shop owner product management
- Service provider service management
- Customer browsing and purchasing
- Solar energy calculator
- User profile management

## Technology Stack

### Frontend
- **Framework**: Flutter
- **State Management**: GetX
- **HTTP Client**: http package

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: PostgreSQL
- **Security**: bcrypt for password hashing, dotenv for environment variables

## Security Improvements

This version includes critical security enhancements:

### ✅ Fixed Security Issues:
1. **Password Security**: 
   - Passwords are now hashed using bcrypt before storage
   - No plain text passwords in the database
   - Minimum password length validation (8 characters)

2. **Credential Management**:
   - All hardcoded database credentials removed
   - Environment variables used for sensitive configuration
   - `.env.example` file provided for setup guidance

3. **SQL Injection Prevention**:
   - Parameterized queries used throughout
   - Input validation and sanitization

4. **Input Validation**:
   - Email format validation
   - Password strength requirements
   - Required field validation

5. **Response Security**:
   - Passwords excluded from API responses
   - Proper error handling without exposing sensitive data

## Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Node.js (14.x or higher)
- PostgreSQL (12.x or higher)

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file (copy from `.env.example`):
```bash
cp .env.example .env
```

4. Update the `.env` file with your database credentials:
```env
DB_USER=postgres
DB_PASSWORD=your_secure_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=solarease
PORT=3000
```

5. Set up the database:
```bash
npm run setup
```

6. Create tables:
```bash
node createProductsTable.js
node createServicesTable.js
```

7. Add role column and admin user:
```bash
node addRoleColumn.js
```

8. Start the server:
```bash
npm start
```

The backend server will run on `http://localhost:3000`

### Frontend Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Run the application:
```bash
flutter run
```

## Project Structure

```
solarease/
├── lib/                    # Flutter source code
│   ├── helpers/           # Helper classes and utilities
│   ├── views/             # UI screens
│   └── main.dart          # Application entry point
├── backend/               # Node.js backend
│   ├── server.js         # Express server and API endpoints
│   ├── setup.js          # Database initialization
│   ├── .env.example      # Environment variables template
│   └── package.json      # Node.js dependencies
├── android/              # Android platform files
├── ios/                  # iOS platform files
├── web/                  # Web platform files
└── pubspec.yaml          # Flutter dependencies
```

## API Endpoints

### Authentication
- `POST /signup` - Register a new user
- `POST /login` - User login

### Products (Shop Owners)
- `POST /addProduct` - Add a new product
- `GET /getProducts/:shopownerId` - Get products by shop owner
- `PUT /updateProduct/:productId` - Update a product
- `DELETE /deleteProduct/:productId` - Delete a product
- `GET /getAllProducts` - Get all products (for customers)

### Services (Service Providers)
- `POST /addService` - Add a new service
- `GET /getServices/:serviceGuyId` - Get services by provider
- `PUT /updateService/:serviceId` - Update a service
- `DELETE /deleteService/:serviceId` - Delete a service
- `GET /getAllServices` - Get all services (for customers)

## User Roles

1. **Customer**: Browse and purchase products/services
2. **Shop Owner**: Manage solar products
3. **Service Guy**: Manage solar services
4. **Admin**: System administration (default credentials in setup)

## Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Security Notes

⚠️ **Important Security Reminders:**

1. Never commit the `.env` file to version control
2. Change default admin password after first login
3. Use strong passwords for database and admin accounts
4. Keep dependencies updated regularly
5. Review and audit code for security vulnerabilities
6. Use HTTPS in production
7. Implement rate limiting for API endpoints
8. Add authentication tokens (JWT) for production use

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is for educational purposes.

## Support

For issues and questions, please open an issue in the repository.
