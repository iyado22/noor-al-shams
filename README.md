# Noor Al-Shams Beauty Salon Management System

A comprehensive full-stack web application for managing a beauty salon business, built with PHP backend and modern frontend technologies.

## 🌟 Features

### For Clients
- **User Registration & Authentication** - Secure account creation with email verification
- **Service Booking** - Browse and book beauty services with real-time availability
- **Appointment Management** - View, modify, and cancel appointments
- **Feedback System** - Rate and review completed services
- **Notifications** - Real-time updates on booking status
- **Profile Management** - Update personal information and preferences

### For Staff
- **Schedule Management** - View daily and weekly schedules
- **Check-in/Check-out** - Track working hours and attendance
- **Appointment Updates** - Update booking status and add notes
- **Client Information** - Access client details and service history
- **Notifications** - Receive booking and schedule updates

### For Administrators
- **Dashboard Analytics** - Comprehensive business insights and statistics
- **User Management** - Manage clients and staff accounts
- **Service Management** - Add, edit, and manage services with pricing
- **Staff Scheduling** - Assign staff to services and manage availability
- **Financial Reports** - Revenue tracking and performance analytics
- **Announcements** - Broadcast messages to users
- **System Management** - User roles, permissions, and system settings

## 🛠️ Technology Stack

### Backend
- **PHP 7.4+** - Server-side scripting
- **MySQL** - Database management
- **PHPMailer** - Email functionality
- **Session Management** - Secure user authentication
- **CSRF Protection** - Security implementation

### Frontend
- **HTML5** - Semantic markup
- **CSS3** - Modern styling with custom properties
- **Vanilla JavaScript** - Interactive functionality
- **Responsive Design** - Mobile-first approach
- **RTL Support** - Arabic language support

### Security Features
- **CSRF Token Protection** - Prevents cross-site request forgery
- **Password Hashing** - Secure password storage with PHP's password_hash()
- **Input Validation** - Server and client-side validation
- **SQL Injection Prevention** - Prepared statements
- **Rate Limiting** - Prevents brute force attacks
- **File Upload Security** - Secure file handling with type validation

## 📋 Requirements

- **PHP 7.4 or higher**
- **MySQL 5.7 or higher**
- **Web server** (Apache/Nginx)
- **SSL Certificate** (recommended for production)

## 🚀 Installation

### 1. Download and Extract
```bash
# Extract the provided ZIP file to your web server directory
unzip noor-alshams-salon.zip
cd noor-alshams-salon
```

### 2. Database Setup
```sql
-- Create database
CREATE DATABASE noor_alshams_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Import the schema
mysql -u root -p noor_alshams_db < database/noor_alshams_schema.sql
```

### 3. Configuration
```bash
# Copy environment configuration
cp backend/config/.env.example backend/config/.env

# Edit the configuration file
nano backend/config/.env
```

Update the following settings in `.env`:
```env
# Database Configuration
DB_HOST=localhost
DB_USER=your_db_username
DB_PASS=your_db_password
DB_NAME=noor_alshams_db

# Email Configuration
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Application Settings
APP_ENV=production
APP_URL=https://yourdomain.com
```

### 4. File Permissions
```bash
# Set proper permissions
chmod 755 backend/
chmod 644 backend/config/.env
chmod 755 backend/uploads/
chmod 755 backend/logs/
```

### 5. Web Server Configuration

#### Apache (.htaccess)
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^api/(.*)$ backend/api/$1 [L]

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
```

#### Nginx
```nginx
location /api/ {
    rewrite ^/api/(.*)$ /backend/api/$1 last;
}

location ~ \.php$ {
    fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
```

## 🔧 Configuration

### Email Setup (Gmail)
1. Enable 2-factor authentication on your Gmail account
2. Generate an app-specific password
3. Update SMTP settings in `.env` file

### SSL Certificate (Production)
```bash
# Using Let's Encrypt (recommended)
certbot --nginx -d yourdomain.com
```

### Backup Setup
```bash
# Create backup script
#!/bin/bash
mysqldump -u username -p noor_alshams_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

## 📱 Usage

### Default Admin Account
- **Email**: admin@nooralshamssalon.com
- **Password**: admin123
- **Note**: Change this password immediately after first login

### Client Registration
1. Visit the website homepage
2. Click "إنشاء حساب" (Create Account)
3. Fill in registration details
4. Verify email address
5. Login and start booking services

### Staff Management
1. Login as admin
2. Navigate to user management
3. Create staff accounts with appropriate roles
4. Staff can login and manage their schedules

## 🔒 Security Best Practices

### Production Deployment
1. **Change default passwords** immediately
2. **Enable HTTPS** with SSL certificate
3. **Regular backups** of database and files
4. **Update PHP** and dependencies regularly
5. **Monitor logs** for suspicious activity
6. **Restrict file permissions** appropriately
7. **Use strong passwords** for all accounts

### Monitoring
```bash
# Monitor error logs
tail -f backend/logs/error.log

# Monitor security logs
tail -f backend/logs/security.log
```

## 📊 API Documentation

### Authentication Endpoints
- `POST /api/auth/login.php` - User login
- `POST /api/auth/register.php` - User registration
- `POST /api/auth/verify.php` - Email verification
- `POST /api/auth/logout.php` - User logout

### Booking Endpoints
- `GET /api/booking/viewClientAppointments.php` - Get user appointments
- `POST /api/booking/addBooking.php` - Create new booking
- `POST /api/booking/modifyBooking.php` - Modify existing booking
- `POST /api/booking/cancelBooking.php` - Cancel booking

### Service Endpoints
- `GET /api/services/viewServices.php` - Get available services
- `POST /api/services/addService.php` - Add new service (Admin)
- `POST /api/services/editService.php` - Edit service (Admin)

## 🐛 Troubleshooting

### Common Issues

#### Database Connection Error
```bash
# Check database credentials in .env
# Verify MySQL service is running
systemctl status mysql
```

#### Email Not Sending
```bash
# Check SMTP settings in .env
# Verify Gmail app password is correct
# Check firewall settings for port 587
```

#### File Upload Issues
```bash
# Check upload directory permissions
chmod 755 backend/uploads/
# Verify PHP upload settings
php -i | grep upload
```

### Debug Mode
```env
# Enable debug mode in .env for development
APP_DEBUG=true
```

## 📞 Support

For technical support and questions:
- **Email**: support@nooralshamssalon.com
- **Documentation**: Check this README file
- **Logs**: Monitor `backend/logs/` directory for errors

## 📄 License

This project is proprietary software. All rights reserved.

## 🔄 Updates

### Version 1.0.0 (Current)
- Initial production release
- Complete booking system
- User management
- Service management
- Staff scheduling
- Admin dashboard
- Security implementation

---

**© 2025 Noor Al-Shams Beauty Salon. All rights reserved.**