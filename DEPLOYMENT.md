# 🚀 Noor Al-Shams Beauty Salon - Production Deployment Guide

## 📋 Pre-Deployment Checklist

### System Requirements
- **PHP 7.4+** with extensions: `mysqli`, `mbstring`, `openssl`, `curl`, `gd`
- **MySQL 5.7+** or **MariaDB 10.2+**
- **Apache 2.4+** with `mod_rewrite` enabled OR **Nginx 1.18+**
- **SSL Certificate** (Let's Encrypt recommended)
- **Minimum 1GB RAM**, **2GB+ recommended**
- **10GB+ disk space**

### Required PHP Extensions
```bash
# Check PHP extensions
php -m | grep -E "(mysqli|mbstring|openssl|curl|gd)"
```

## 🔧 Step-by-Step Deployment

### 1. Upload Files to Server
```bash
# Upload the entire package to your web server
# Example for cPanel/shared hosting:
# - Upload the ZIP file via File Manager
# - Extract to public_html or desired directory

# Example for VPS/dedicated server:
cd /var/www/html
wget https://your-domain.com/noor-alshams-salon.zip
unzip noor-alshams-salon.zip
mv production-package nooralshamssalon
```

### 2. Set File Permissions
```bash
# For shared hosting (via cPanel File Manager):
# Set folders to 755, files to 644

# For VPS/dedicated server:
cd /var/www/html/nooralshamssalon
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

# Special permissions for upload and log directories
chmod 755 backend/uploads/
chmod 755 backend/logs/
chown -R www-data:www-data backend/uploads/
chown -R www-data:www-data backend/logs/

# Secure the config file
chmod 600 backend/config/.env
```

### 3. Database Setup

#### Create Database
```sql
-- Via phpMyAdmin or MySQL command line
CREATE DATABASE noor_alshams_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create database user (recommended for security)
CREATE USER 'salon_user'@'localhost' IDENTIFIED BY 'your_secure_password_here';
GRANT ALL PRIVILEGES ON noor_alshams_db.* TO 'salon_user'@'localhost';
FLUSH PRIVILEGES;
```

#### Import Database Schema
```bash
# Via command line
mysql -u salon_user -p noor_alshams_db < noor_alshams_schema.sql

# Via phpMyAdmin:
# 1. Select the noor_alshams_db database
# 2. Go to Import tab
# 3. Choose noor_alshams_schema.sql file
# 4. Click Go
```

### 4. Environment Configuration

#### Copy and Edit Configuration File
```bash
cp backend/config/.env.example backend/config/.env
nano backend/config/.env  # or use your preferred editor
```

#### Required Configuration Settings
```env
# Database Configuration
DB_HOST=localhost
DB_USER=salon_user
DB_PASS=your_secure_password_here
DB_NAME=noor_alshams_db

# Email Configuration (Gmail SMTP)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-gmail-app-password

# Application Settings
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com
APP_NAME="Noor Al-Shams Beauty Salon"

# Security Settings
SESSION_LIFETIME=7200
CSRF_TOKEN_LIFETIME=3600
PASSWORD_MIN_LENGTH=8
```

### 5. Email Setup (Gmail)

#### Generate Gmail App Password
1. Enable 2-Factor Authentication on your Gmail account
2. Go to Google Account settings → Security → App passwords
3. Generate a new app password for "Mail"
4. Use this password in the `SMTP_PASS` setting

### 6. Web Server Configuration

#### Apache Configuration (.htaccess)
The `.htaccess` file is already included. Ensure `mod_rewrite` is enabled:
```bash
# Enable mod_rewrite (Ubuntu/Debian)
sudo a2enmod rewrite
sudo systemctl restart apache2
```

#### Nginx Configuration (if using Nginx)
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/html/nooralshamssalon/frontend;
    index index.html;

    # SSL Configuration
    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-Frame-Options DENY always;
    add_header X-XSS-Protection "1; mode=block" always;

    # API Routes
    location /api/ {
        alias /var/www/html/nooralshamssalon/backend/api/;
        try_files $uri $uri/ =404;
        
        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $request_filename;
        }
    }

    # Frontend Routes
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Static Assets Caching
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
}
```

### 7. SSL Certificate Setup

#### Using Let's Encrypt (Free)
```bash
# Install Certbot
sudo apt update
sudo apt install certbot python3-certbot-apache

# Get SSL certificate
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com

# Set up auto-renewal
sudo crontab -e
# Add this line:
0 12 * * * /usr/bin/certbot renew --quiet
```

#### Using cPanel (Shared Hosting)
1. Go to cPanel → SSL/TLS
2. Use Let's Encrypt or upload your certificate
3. Force HTTPS redirect

### 8. Security Hardening

#### File Security
```bash
# Protect sensitive files
echo "deny from all" > backend/config/.htaccess
echo "deny from all" > backend/logs/.htaccess

# Remove unnecessary files
rm -f backend/config/.env.example
rm -f DEPLOYMENT.md
rm -f README.md
```

#### Database Security
```sql
-- Remove test data (if any)
-- Change default admin password immediately after first login
UPDATE users SET password = '$2y$10$newhashedpassword' WHERE email = 'admin@nooralshamssalon.com';
```

### 9. Testing Deployment

#### Functionality Tests
1. **Homepage**: Visit `https://yourdomain.com`
2. **Registration**: Test user registration process
3. **Login**: Test admin login with default credentials
4. **Email**: Test email verification system
5. **Booking**: Test appointment booking system
6. **Admin Panel**: Test admin dashboard functionality

#### Performance Tests
```bash
# Test page load speed
curl -w "@curl-format.txt" -o /dev/null -s "https://yourdomain.com"

# Check database connection
mysql -u salon_user -p noor_alshams_db -e "SELECT COUNT(*) FROM users;"
```

### 10. Backup Setup

#### Automated Backup Script
```bash
# Create backup script
sudo nano /usr/local/bin/salon-backup.sh
```

```bash
#!/bin/bash
# Noor Al-Shams Salon Backup Script

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/salon"
DB_USER="salon_user"
DB_PASS="your_password"
DB_NAME="noor_alshams_db"
SITE_DIR="/var/www/html/nooralshamssalon"

# Create backup directory
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Files backup
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz $SITE_DIR

# Keep only last 7 days of backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

```bash
# Make script executable
sudo chmod +x /usr/local/bin/salon-backup.sh

# Add to crontab for daily backups
sudo crontab -e
# Add: 0 2 * * * /usr/local/bin/salon-backup.sh
```

### 11. Monitoring Setup

#### Log Monitoring
```bash
# Monitor error logs
tail -f /var/log/apache2/error.log
tail -f backend/logs/error.log

# Monitor access logs
tail -f /var/log/apache2/access.log
```

#### Performance Monitoring
```bash
# Install monitoring tools
sudo apt install htop iotop

# Monitor system resources
htop
```

## 🔐 Security Checklist

- [ ] Changed default admin password
- [ ] SSL certificate installed and working
- [ ] File permissions set correctly
- [ ] Database user has minimal required privileges
- [ ] `.env` file is not publicly accessible
- [ ] Error reporting disabled in production
- [ ] Regular backups configured
- [ ] Security headers configured
- [ ] Firewall configured (if applicable)
- [ ] PHP version is up to date

## 🚨 Troubleshooting

### Common Issues

#### Database Connection Error
```bash
# Check MySQL service
sudo systemctl status mysql

# Test database connection
mysql -u salon_user -p noor_alshams_db

# Check credentials in .env file
cat backend/config/.env | grep DB_
```

#### File Upload Issues
```bash
# Check PHP upload settings
php -i | grep -E "(upload_max_filesize|post_max_size|max_file_uploads)"

# Check directory permissions
ls -la backend/uploads/
```

#### Email Not Working
```bash
# Test SMTP connection
telnet smtp.gmail.com 587

# Check Gmail app password
# Verify firewall allows outbound port 587
```

#### 500 Internal Server Error
```bash
# Check Apache error log
tail -f /var/log/apache2/error.log

# Check PHP error log
tail -f backend/logs/error.log

# Verify .htaccess syntax
apache2ctl configtest
```

### Performance Issues
```bash
# Enable PHP OPcache
echo "opcache.enable=1" >> /etc/php/7.4/apache2/php.ini

# Optimize MySQL
mysql_secure_installation

# Enable compression in Apache
sudo a2enmod deflate
```

## 📞 Support Information

### Default Login Credentials
- **Admin Email**: `admin@nooralshamssalon.com`
- **Admin Password**: `password`
- **⚠️ IMPORTANT**: Change this password immediately after first login!

### Log Files Locations
- **Application Logs**: `backend/logs/error.log`
- **Security Logs**: `backend/logs/security.log`
- **Apache Logs**: `/var/log/apache2/`
- **PHP Logs**: `/var/log/php/`

### Configuration Files
- **Environment**: `backend/config/.env`
- **Database**: `backend/config/database.php`
- **Apache**: `.htaccess`

## 🎉 Post-Deployment Steps

1. **Change Admin Password**: Login and update the default password
2. **Configure Services**: Add your salon's services and pricing
3. **Add Staff Members**: Create staff accounts and profiles
4. **Test Booking System**: Make a test appointment
5. **Configure Email Templates**: Customize notification emails
6. **Set Business Hours**: Update working hours in settings
7. **Add Content**: Update homepage content and images
8. **SEO Setup**: Configure meta tags and descriptions

---

**🎊 Congratulations! Your Noor Al-Shams Beauty Salon website is now live!**

For technical support or questions, please check the log files first, then contact your system administrator.