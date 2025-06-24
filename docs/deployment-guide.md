# 🚀 Production Deployment Guide

## 📋 Overview

This guide provides step-by-step instructions for deploying the Noor Al-Shams Beauty Salon application to production environments. It covers server setup, application deployment, security configuration, and monitoring setup.

---

## 🏗️ Infrastructure Requirements

### Minimum Server Specifications

**Web Server (2 instances for load balancing):**
- CPU: 4 cores (2.4 GHz)
- RAM: 8GB
- Storage: 100GB SSD
- OS: Ubuntu 22.04 LTS
- Network: 1Gbps

**Database Server:**
- CPU: 4 cores (2.4 GHz)
- RAM: 16GB
- Storage: 200GB SSD (with backup storage)
- OS: Ubuntu 22.04 LTS
- Network: 1Gbps

**Load Balancer:**
- CPU: 2 cores
- RAM: 4GB
- Storage: 50GB SSD
- OS: Ubuntu 22.04 LTS

---

## 🔧 Server Setup

### 1. Initial Server Configuration

```bash
#!/bin/bash
# server-setup.sh

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y curl wget git unzip software-properties-common

# Configure timezone
sudo timedatectl set-timezone Asia/Riyadh

# Configure locale
sudo locale-gen ar_SA.UTF-8
sudo update-locale LANG=ar_SA.UTF-8

# Create application user
sudo useradd -m -s /bin/bash salonapp
sudo usermod -aG sudo salonapp

# Configure SSH security
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
```

### 2. Web Server Setup (Nginx + PHP)

```bash
#!/bin/bash
# web-server-setup.sh

# Install Nginx
sudo apt install -y nginx

# Install PHP 8.1 and extensions
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.1-fpm php8.1-mysql php8.1-mbstring php8.1-xml \
  php8.1-curl php8.1-gd php8.1-zip php8.1-intl php8.1-bcmath

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Configure PHP-FPM
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 10M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/8.1/fpm/php.ini

# Restart services
sudo systemctl restart php8.1-fpm
sudo systemctl restart nginx
```

### 3. Database Server Setup

```bash
#!/bin/bash
# database-setup.sh

# Install MySQL 8.0
sudo apt update
sudo apt install -y mysql-server

# Secure MySQL installation
sudo mysql_secure_installation

# Configure MySQL for production
sudo tee /etc/mysql/mysql.conf.d/production.cnf << EOF
[mysqld]
# Performance settings
innodb_buffer_pool_size = 8G
innodb_log_file_size = 512M
innodb_flush_log_at_trx_commit = 2
query_cache_type = 1
query_cache_size = 256M

# Connection settings
max_connections = 200
connect_timeout = 10
wait_timeout = 600
interactive_timeout = 600

# Security settings
bind-address = 10.0.0.0/8
skip-name-resolve
local-infile = 0

# Logging
log-error = /var/log/mysql/error.log
slow-query-log = 1
slow-query-log-file = /var/log/mysql/slow.log
long_query_time = 2

# Binary logging for replication
server-id = 1
log-bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7
EOF

# Restart MySQL
sudo systemctl restart mysql
```

---

## 🔐 SSL Certificate Setup

### 1. Let's Encrypt Certificate

```bash
#!/bin/bash
# ssl-setup.sh

# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obtain SSL certificate
sudo certbot --nginx -d nooralshamssalon.com -d www.nooralshamssalon.com \
  --email admin@nooralshamssalon.com --agree-tos --non-interactive

# Set up auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 2. Nginx SSL Configuration

```nginx
# /etc/nginx/sites-available/nooralshamssalon.com
server {
    listen 80;
    server_name nooralshamssalon.com www.nooralshamssalon.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name nooralshamssalon.com www.nooralshamssalon.com;
    
    root /var/www/nooralshamssalon/dist;
    index index.html;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/nooralshamssalon.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/nooralshamssalon.com/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:;" always;
    
    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # Frontend Routes
    location / {
        try_files $uri $uri/ /index.html;
        
        # Cache static assets
        location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            access_log off;
        }
    }
    
    # API Routes
    location /api/ {
        alias /var/www/nooralshamssalon/backend/api/;
        try_files $uri $uri/ =404;
        
        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            
            # Security
            fastcgi_hide_header X-Powered-By;
            fastcgi_read_timeout 300;
        }
    }
    
    # Deny access to sensitive files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    location ~ \.(env|log|sql)$ {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    location /api/ {
        limit_req zone=api burst=20 nodelay;
    }
}
```

---

## 📦 Application Deployment

### 1. Automated Deployment Script

```bash
#!/bin/bash
# deploy.sh

set -e

# Configuration
APP_DIR="/var/www/nooralshamssalon"
BACKUP_DIR="/var/backups/nooralshamssalon"
REPO_URL="https://github.com/your-org/noor-alshams-salon.git"
BRANCH="main"

echo "🚀 Starting deployment..."

# Create backup of current version
if [ -d "$APP_DIR" ]; then
    echo "📦 Creating backup..."
    sudo cp -r $APP_DIR $BACKUP_DIR/backup-$(date +%Y%m%d_%H%M%S)
fi

# Clone or update repository
if [ ! -d "$APP_DIR" ]; then
    echo "📥 Cloning repository..."
    sudo git clone $REPO_URL $APP_DIR
else
    echo "🔄 Updating repository..."
    cd $APP_DIR
    sudo git fetch origin
    sudo git reset --hard origin/$BRANCH
fi

cd $APP_DIR

# Set permissions
sudo chown -R salonapp:www-data $APP_DIR
sudo chmod -R 755 $APP_DIR
sudo chmod -R 775 $APP_DIR/backend/uploads
sudo chmod -R 775 $APP_DIR/backend/logs

# Install dependencies
echo "📦 Installing dependencies..."
npm ci --production
sudo -u salonapp composer install --no-dev --optimize-autoloader

# Build frontend
echo "🏗️ Building frontend..."
npm run build

# Database migration
echo "🗄️ Running database migrations..."
php $APP_DIR/backend/scripts/migrate.php

# Clear caches
echo "🧹 Clearing caches..."
sudo rm -rf $APP_DIR/backend/cache/*
sudo systemctl reload php8.1-fpm

# Restart services
echo "🔄 Restarting services..."
sudo systemctl reload nginx

# Health check
echo "🏥 Running health check..."
sleep 5
if curl -f -s https://nooralshamssalon.com/api/health > /dev/null; then
    echo "✅ Deployment successful!"
else
    echo "❌ Health check failed!"
    exit 1
fi

echo "🎉 Deployment completed successfully!"
```

### 2. Environment Configuration

```bash
# /var/www/nooralshamssalon/backend/config/.env
# Production Environment Configuration

# Application
APP_ENV=production
APP_DEBUG=false
APP_URL=https://nooralshamssalon.com
APP_NAME="Noor Al-Shams Beauty Salon"

# Database
DB_HOST=10.0.1.100
DB_PORT=3306
DB_NAME=noor_alshams_prod
DB_USER=salon_app
DB_PASS=your_secure_database_password

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=noreply@nooralshamssalon.com
SMTP_PASS=your_gmail_app_password
SMTP_FROM_NAME="Noor Al-Shams Beauty Salon"

# Security
JWT_SECRET=your_jwt_secret_key_here
CSRF_SECRET=your_csrf_secret_key_here
ENCRYPTION_KEY=your_encryption_key_here

# File Upload
UPLOAD_MAX_SIZE=10485760
ALLOWED_EXTENSIONS=jpg,jpeg,png,gif,pdf

# Cache
CACHE_DRIVER=file
CACHE_TTL=3600

# Session
SESSION_LIFETIME=7200
SESSION_SECURE=true
SESSION_HTTPONLY=true

# Rate Limiting
RATE_LIMIT_REQUESTS=1000
RATE_LIMIT_WINDOW=3600

# Logging
LOG_LEVEL=error
LOG_FILE=/var/www/nooralshamssalon/backend/logs/app.log

# Backup
BACKUP_ENABLED=true
BACKUP_SCHEDULE="0 2 * * *"
BACKUP_RETENTION_DAYS=30
```

---

## 📊 Monitoring Setup

### 1. System Monitoring with Prometheus

```yaml
# docker-compose.monitoring.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=secure_password
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana_data:/var/lib/grafana
    restart: unless-stopped

  node_exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
```

### 2. Application Health Check

```php
<?php
// /var/www/nooralshamssalon/backend/api/health.php

header('Content-Type: application/json');

$health = [
    'status' => 'healthy',
    'timestamp' => date('c'),
    'checks' => []
];

// Database check
try {
    $pdo = new PDO(
        "mysql:host={$_ENV['DB_HOST']};dbname={$_ENV['DB_NAME']}",
        $_ENV['DB_USER'],
        $_ENV['DB_PASS']
    );
    $pdo->query('SELECT 1');
    $health['checks']['database'] = 'healthy';
} catch (Exception $e) {
    $health['checks']['database'] = 'unhealthy';
    $health['status'] = 'unhealthy';
}

// File system check
if (is_writable('/var/www/nooralshamssalon/backend/uploads')) {
    $health['checks']['filesystem'] = 'healthy';
} else {
    $health['checks']['filesystem'] = 'unhealthy';
    $health['status'] = 'unhealthy';
}

// Memory check
$memory_usage = memory_get_usage(true);
$memory_limit = ini_get('memory_limit');
$memory_limit_bytes = return_bytes($memory_limit);
$memory_percentage = ($memory_usage / $memory_limit_bytes) * 100;

if ($memory_percentage < 80) {
    $health['checks']['memory'] = 'healthy';
} else {
    $health['checks']['memory'] = 'warning';
}

$health['metrics'] = [
    'memory_usage' => $memory_usage,
    'memory_percentage' => round($memory_percentage, 2)
];

http_response_code($health['status'] === 'healthy' ? 200 : 503);
echo json_encode($health, JSON_PRETTY_PRINT);

function return_bytes($val) {
    $val = trim($val);
    $last = strtolower($val[strlen($val)-1]);
    $val = (int) $val;
    switch($last) {
        case 'g': $val *= 1024;
        case 'm': $val *= 1024;
        case 'k': $val *= 1024;
    }
    return $val;
}
?>
```

### 3. Log Aggregation with ELK Stack

```yaml
# docker-compose.elk.yml
version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.5.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:8.5.0
    container_name: kibana
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch

  filebeat:
    image: docker.elastic.co/beats/filebeat:8.5.0
    container_name: filebeat
    user: root
    volumes:
      - ./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/log:/var/log:ro
      - /var/www/nooralshamssalon/backend/logs:/app/logs:ro
    depends_on:
      - elasticsearch

volumes:
  elasticsearch_data:
```

---

## 🔄 Backup and Recovery

### 1. Automated Backup Script

```bash
#!/bin/bash
# backup.sh

# Configuration
BACKUP_DIR="/var/backups/nooralshamssalon"
DB_NAME="noor_alshams_prod"
DB_USER="backup_user"
DB_PASS="backup_password"
APP_DIR="/var/www/nooralshamssalon"
S3_BUCKET="noor-alshams-backups"
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🔄 Starting backup process..."

# Database backup
echo "📊 Backing up database..."
mysqldump --single-transaction --routines --triggers \
  -u $DB_USER -p$DB_PASS $DB_NAME \
  | gzip > $BACKUP_DIR/db_backup_$TIMESTAMP.sql.gz

# Application files backup
echo "📁 Backing up application files..."
tar -czf $BACKUP_DIR/app_backup_$TIMESTAMP.tar.gz \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='backend/logs/*' \
  $APP_DIR

# Upload to S3 (if configured)
if command -v aws &> /dev/null; then
    echo "☁️ Uploading to S3..."
    aws s3 cp $BACKUP_DIR/db_backup_$TIMESTAMP.sql.gz s3://$S3_BUCKET/database/
    aws s3 cp $BACKUP_DIR/app_backup_$TIMESTAMP.tar.gz s3://$S3_BUCKET/application/
fi

# Cleanup old backups
echo "🧹 Cleaning up old backups..."
find $BACKUP_DIR -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

# Verify backup integrity
echo "✅ Verifying backup integrity..."
gunzip -t $BACKUP_DIR/db_backup_$TIMESTAMP.sql.gz
tar -tzf $BACKUP_DIR/app_backup_$TIMESTAMP.tar.gz > /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Backup completed successfully: $TIMESTAMP"
    
    # Send notification
    curl -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
      -d chat_id="$TELEGRAM_CHAT_ID" \
      -d text="✅ Backup completed successfully for Noor Al-Shams Salon: $TIMESTAMP"
else
    echo "❌ Backup verification failed!"
    
    # Send error notification
    curl -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
      -d chat_id="$TELEGRAM_CHAT_ID" \
      -d text="❌ Backup failed for Noor Al-Shams Salon: $TIMESTAMP"
    
    exit 1
fi
```

### 2. Recovery Procedures

```bash
#!/bin/bash
# restore.sh

# Configuration
BACKUP_DIR="/var/backups/nooralshamssalon"
DB_NAME="noor_alshams_prod"
DB_USER="root"
APP_DIR="/var/www/nooralshamssalon"

# Check if backup file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <backup_timestamp>"
    echo "Available backups:"
    ls -la $BACKUP_DIR/db_backup_*.sql.gz | awk '{print $9}' | sed 's/.*db_backup_//' | sed 's/.sql.gz//'
    exit 1
fi

TIMESTAMP=$1

echo "🔄 Starting restore process for backup: $TIMESTAMP"

# Stop application services
echo "⏹️ Stopping services..."
sudo systemctl stop nginx
sudo systemctl stop php8.1-fpm

# Backup current state before restore
echo "📦 Creating pre-restore backup..."
mysqldump --single-transaction -u $DB_USER -p $DB_NAME \
  | gzip > $BACKUP_DIR/pre_restore_$(date +%Y%m%d_%H%M%S).sql.gz

# Restore database
echo "📊 Restoring database..."
gunzip -c $BACKUP_DIR/db_backup_$TIMESTAMP.sql.gz | mysql -u $DB_USER -p $DB_NAME

# Restore application files
echo "📁 Restoring application files..."
cd /var/www
sudo rm -rf nooralshamssalon_old
sudo mv nooralshamssalon nooralshamssalon_old
sudo tar -xzf $BACKUP_DIR/app_backup_$TIMESTAMP.tar.gz

# Set permissions
sudo chown -R salonapp:www-data $APP_DIR
sudo chmod -R 755 $APP_DIR
sudo chmod -R 775 $APP_DIR/backend/uploads
sudo chmod -R 775 $APP_DIR/backend/logs

# Start services
echo "▶️ Starting services..."
sudo systemctl start php8.1-fpm
sudo systemctl start nginx

# Health check
echo "🏥 Running health check..."
sleep 10
if curl -f -s https://nooralshamssalon.com/api/health > /dev/null; then
    echo "✅ Restore completed successfully!"
else
    echo "❌ Health check failed after restore!"
    exit 1
fi
```

---

## 🔒 Security Hardening

### 1. Server Security

```bash
#!/bin/bash
# security-hardening.sh

# Install fail2ban
sudo apt install -y fail2ban

# Configure fail2ban
sudo tee /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
port = http,https
logpath = /var/log/nginx/error.log

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 10
EOF

# Install and configure ClamAV
sudo apt install -y clamav clamav-daemon
sudo freshclam
sudo systemctl enable clamav-daemon

# Configure automatic security updates
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Harden kernel parameters
sudo tee -a /etc/sysctl.conf << EOF
# Network security
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.tcp_syncookies=1
net.ipv4.conf.all.accept_redirects=0
net.ipv6.conf.all.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.all.accept_source_route=0
net.ipv6.conf.all.accept_source_route=0
net.ipv4.conf.all.log_martians=1
EOF

sudo sysctl -p

# Restart services
sudo systemctl restart fail2ban
sudo systemctl restart clamav-daemon
```

### 2. Application Security

```php
<?php
// Security middleware for API endpoints

class SecurityMiddleware {
    public static function validateRequest() {
        // Rate limiting
        self::checkRateLimit();
        
        // CSRF protection
        self::validateCSRFToken();
        
        // Input sanitization
        self::sanitizeInput();
        
        // SQL injection prevention
        self::validateSQLInjection();
    }
    
    private static function checkRateLimit() {
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);
        
        $key = 'rate_limit:' . $_SERVER['REMOTE_ADDR'];
        $requests = $redis->incr($key);
        
        if ($requests === 1) {
            $redis->expire($key, 3600); // 1 hour window
        }
        
        if ($requests > 1000) { // 1000 requests per hour
            http_response_code(429);
            die(json_encode(['error' => 'Rate limit exceeded']));
        }
    }
    
    private static function validateCSRFToken() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
            
            if (!hash_equals($_SESSION['csrf_token'], $token)) {
                http_response_code(403);
                die(json_encode(['error' => 'Invalid CSRF token']));
            }
        }
    }
    
    private static function sanitizeInput() {
        array_walk_recursive($_POST, function(&$value) {
            $value = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
        });
        
        array_walk_recursive($_GET, function(&$value) {
            $value = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
        });
    }
    
    private static function validateSQLInjection() {
        $dangerous_patterns = [
            '/(\s|^)(union|select|insert|update|delete|drop|create|alter|exec|execute)(\s|$)/i',
            '/(\s|^)(or|and)(\s|$).*(\s|^)(=|like)(\s|$)/i',
            '/(\s|^)(\'|"|`|;|--|\*|\/\*|\*\/)/i'
        ];
        
        $input = json_encode($_REQUEST);
        
        foreach ($dangerous_patterns as $pattern) {
            if (preg_match($pattern, $input)) {
                error_log("SQL Injection attempt detected: " . $input);
                http_response_code(400);
                die(json_encode(['error' => 'Invalid request']));
            }
        }
    }
}
?>
```

---

## 📈 Performance Optimization

### 1. Nginx Optimization

```nginx
# /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    # Basic settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;
    
    # Buffer settings
    client_body_buffer_size 128k;
    client_max_body_size 10m;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 4k;
    output_buffers 1 32k;
    postpone_output 1460;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
    
    # Cache settings
    open_file_cache max=1000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
    
    include /etc/nginx/sites-enabled/*;
}
```

### 2. PHP-FPM Optimization

```ini
; /etc/php/8.1/fpm/pool.d/www.conf
[www]
user = www-data
group = www-data

listen = /var/run/php/php8.1-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660

; Process management
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 500

; Performance tuning
request_terminate_timeout = 300
request_slowlog_timeout = 10
slowlog = /var/log/php8.1-fpm-slow.log

; Security
security.limit_extensions = .php
```

---

## 🚨 Rollback Procedures

### 1. Automated Rollback Script

```bash
#!/bin/bash
# rollback.sh

set -e

APP_DIR="/var/www/nooralshamssalon"
BACKUP_DIR="/var/backups/nooralshamssalon"

echo "🔄 Starting rollback procedure..."

# Find latest backup
LATEST_BACKUP=$(ls -t $BACKUP_DIR/backup-* | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup found for rollback!"
    exit 1
fi

echo "📦 Rolling back to: $LATEST_BACKUP"

# Stop services
sudo systemctl stop nginx
sudo systemctl stop php8.1-fpm

# Create emergency backup of current state
sudo mv $APP_DIR $APP_DIR.failed-$(date +%Y%m%d_%H%M%S)

# Restore from backup
sudo cp -r $LATEST_BACKUP $APP_DIR

# Set permissions
sudo chown -R salonapp:www-data $APP_DIR
sudo chmod -R 755 $APP_DIR

# Start services
sudo systemctl start php8.1-fpm
sudo systemctl start nginx

# Health check
sleep 10
if curl -f -s https://nooralshamssalon.com/api/health > /dev/null; then
    echo "✅ Rollback completed successfully!"
else
    echo "❌ Rollback failed! Manual intervention required."
    exit 1
fi
```

---

## 📞 Support and Maintenance

### 1. Maintenance Schedule

```bash
# /etc/cron.d/nooralshamssalon-maintenance

# Daily backup at 2 AM
0 2 * * * salonapp /var/www/nooralshamssalon/scripts/backup.sh

# Weekly log rotation at 3 AM on Sunday
0 3 * * 0 root /usr/sbin/logrotate /etc/logrotate.d/nooralshamssalon

# Monthly security updates at 4 AM on 1st
0 4 1 * * root /usr/bin/unattended-upgrade

# Daily health check every hour
0 * * * * salonapp curl -f -s https://nooralshamssalon.com/api/health || echo "Health check failed" | mail -s "Health Check Alert" admin@nooralshamssalon.com
```

### 2. Emergency Contacts

```
Primary Contact: System Administrator
Email: admin@nooralshamssalon.com
Phone: +966-XXX-XXXX

Secondary Contact: Development Team Lead
Email: dev@nooralshamssalon.com
Phone: +966-XXX-XXXX

Hosting Provider: [Provider Name]
Support: support@provider.com
Phone: +966-XXX-XXXX
```

---

## ✅ Post-Deployment Checklist

- [ ] SSL certificate installed and working
- [ ] All services running (Nginx, PHP-FPM, MySQL)
- [ ] Database connection successful
- [ ] File permissions set correctly
- [ ] Backup system configured and tested
- [ ] Monitoring and alerting active
- [ ] Security hardening applied
- [ ] Performance optimization configured
- [ ] Health checks passing
- [ ] DNS records configured
- [ ] CDN configured (if applicable)
- [ ] Email delivery working
- [ ] Error logging configured
- [ ] Rate limiting active
- [ ] CSRF protection enabled
- [ ] User acceptance testing completed

---

*Last Updated: January 15, 2024*  
*Deployment Version: 1.0*