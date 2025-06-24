# 🗄️ Database Schema Documentation

## 📊 Database Overview

**Database Name:** `noor_alshams_salon`  
**Engine:** MySQL 8.0+  
**Character Set:** `utf8mb4`  
**Collation:** `utf8mb4_unicode_ci`  

---

## 📋 Table Structure

### 1. Users Table
Primary table for all system users (clients, staff, admins).

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL COMMENT 'Full name in Arabic',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Email address for login',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Hashed password using bcrypt',
    phone VARCHAR(20) COMMENT 'Phone number with country code',
    date_of_birth DATE COMMENT 'Date of birth for age verification',
    role ENUM('client', 'staff', 'admin') DEFAULT 'client' COMMENT 'User role',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Account status',
    email_verified_at TIMESTAMP NULL COMMENT 'Email verification timestamp',
    last_login_at TIMESTAMP NULL COMMENT 'Last login timestamp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for performance
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (is_active),
    INDEX idx_phone (phone)
) ENGINE=InnoDB COMMENT='System users table';
```

**Sample Data:**
```sql
INSERT INTO users VALUES
(1, 'سارة أحمد محمد', 'sara@example.com', '$2y$10$hash...', '+966501234567', '1990-05-15', 'client', 1, '2024-01-10 10:00:00', '2024-01-15 09:30:00', '2024-01-10 08:00:00', '2024-01-15 09:30:00'),
(2, 'نور محمد علي', 'noor@salon.com', '$2y$10$hash...', '+966507654321', '1985-08-20', 'staff', 1, '2024-01-05 14:00:00', '2024-01-15 08:00:00', '2024-01-05 12:00:00', '2024-01-15 08:00:00');
```

---

### 2. Service Categories Table
Categories for organizing services.

```sql
CREATE TABLE service_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Category name in Arabic',
    description TEXT COMMENT 'Category description',
    icon VARCHAR(50) COMMENT 'Icon class name',
    sort_order INT DEFAULT 0 COMMENT 'Display order',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_active_sort (is_active, sort_order)
) ENGINE=InnoDB COMMENT='Service categories';
```

**Sample Data:**
```sql
INSERT INTO service_categories VALUES
(1, 'العناية بالشعر', 'خدمات قص وصبغ وتصفيف الشعر', 'hair-icon', 1, 1, NOW(), NOW()),
(2, 'العناية بالبشرة', 'خدمات تنظيف وعلاج البشرة', 'skin-icon', 2, 1, NOW(), NOW()),
(3, 'المكياج', 'خدمات المكياج للمناسبات', 'makeup-icon', 3, 1, NOW(), NOW());
```

---

### 3. Services Table
Available salon services.

```sql
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Service name in Arabic',
    description TEXT COMMENT 'Detailed service description',
    price DECIMAL(10,2) NOT NULL COMMENT 'Service price in SAR',
    duration INT NOT NULL COMMENT 'Duration in minutes',
    category_id INT COMMENT 'Reference to service category',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Service availability',
    image_url VARCHAR(255) COMMENT 'Service image URL',
    requirements TEXT COMMENT 'Special requirements or notes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (category_id) REFERENCES service_categories(id) ON DELETE SET NULL,
    
    INDEX idx_category (category_id),
    INDEX idx_active (is_active),
    INDEX idx_price (price),
    INDEX idx_duration (duration)
) ENGINE=InnoDB COMMENT='Salon services';
```

**Sample Data:**
```sql
INSERT INTO services VALUES
(1, 'قص شعر عادي', 'قص شعر عادي بأحدث الطرق والأدوات', 50.00, 30, 1, 1, 'https://example.com/haircut.jpg', 'يفضل غسل الشعر قبل القدوم', NOW(), NOW()),
(2, 'صبغة شعر كاملة', 'صبغة شعر كاملة بألوان متنوعة', 150.00, 120, 1, 1, 'https://example.com/hair-color.jpg', 'اختبار حساسية مطلوب', NOW(), NOW()),
(3, 'تنظيف بشرة عميق', 'تنظيف عميق للبشرة وإزالة الرؤوس السوداء', 100.00, 60, 2, 1, 'https://example.com/facial.jpg', 'مناسب لجميع أنواع البشرة', NOW(), NOW());
```

---

### 4. Staff Profiles Table
Extended information for staff members.

```sql
CREATE TABLE staff_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT 'Reference to users table',
    specialization VARCHAR(100) COMMENT 'Staff specialization',
    experience_years INT DEFAULT 0 COMMENT 'Years of experience',
    bio TEXT COMMENT 'Staff biography',
    certifications JSON COMMENT 'Professional certifications',
    working_hours JSON COMMENT 'Weekly working schedule',
    hourly_rate DECIMAL(8,2) COMMENT 'Hourly rate for commission calculation',
    is_available BOOLEAN DEFAULT TRUE COMMENT 'Current availability status',
    hire_date DATE COMMENT 'Date of hiring',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user (user_id),
    INDEX idx_available (is_available),
    INDEX idx_specialization (specialization)
) ENGINE=InnoDB COMMENT='Staff member profiles';
```

**Sample Data:**
```sql
INSERT INTO staff_profiles VALUES
(1, 2, 'خبيرة شعر', 5, 'خبيرة في قص وصبغ الشعر مع 5 سنوات خبرة', 
 '["شهادة التجميل المتقدم", "دورة الصبغات الحديثة"]',
 '{"saturday": {"start": "09:00", "end": "17:00"}, "sunday": {"start": "09:00", "end": "17:00"}, "monday": {"start": "09:00", "end": "17:00"}}',
 75.00, 1, '2019-03-15', NOW(), NOW());
```

---

### 5. Bookings Table
Customer appointment bookings.

```sql
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL COMMENT 'Reference to client user',
    staff_id INT NOT NULL COMMENT 'Assigned staff member',
    service_id INT NOT NULL COMMENT 'Booked service',
    appointment_date DATE NOT NULL COMMENT 'Appointment date',
    appointment_time TIME NOT NULL COMMENT 'Appointment time',
    status ENUM('pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show') DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL COMMENT 'Total booking amount',
    paid_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Amount paid',
    payment_status ENUM('pending', 'partial', 'paid', 'refunded') DEFAULT 'pending',
    payment_method ENUM('cash', 'card', 'online', 'bank_transfer') COMMENT 'Payment method used',
    confirmation_code VARCHAR(20) UNIQUE COMMENT 'Booking confirmation code',
    notes TEXT COMMENT 'Client notes or special requests',
    staff_notes TEXT COMMENT 'Staff notes about the service',
    cancelled_at TIMESTAMP NULL COMMENT 'Cancellation timestamp',
    cancellation_reason TEXT COMMENT 'Reason for cancellation',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT,
    
    INDEX idx_client (client_id),
    INDEX idx_staff (staff_id),
    INDEX idx_service (service_id),
    INDEX idx_date (appointment_date),
    INDEX idx_status (status),
    INDEX idx_payment_status (payment_status),
    INDEX idx_confirmation (confirmation_code),
    
    -- Prevent double booking for same staff at same time
    UNIQUE KEY unique_staff_datetime (staff_id, appointment_date, appointment_time)
) ENGINE=InnoDB COMMENT='Customer bookings';
```

**Sample Data:**
```sql
INSERT INTO bookings VALUES
(1, 1, 2, 1, '2024-02-15', '10:00:00', 'confirmed', 50.00, 0.00, 'pending', NULL, 'NS2024-001', 'أول زيارة للصالون', NULL, NULL, NULL, NOW(), NOW()),
(2, 1, 2, 2, '2024-02-20', '14:00:00', 'pending', 150.00, 0.00, 'pending', NULL, 'NS2024-002', 'أريد لون بني فاتح', NULL, NULL, NULL, NOW(), NOW());
```

---

### 6. Attendance Table
Staff attendance tracking.

```sql
CREATE TABLE attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL COMMENT 'Reference to staff user',
    work_date DATE NOT NULL COMMENT 'Work date',
    check_in_time TIMESTAMP NOT NULL COMMENT 'Check-in timestamp',
    check_out_time TIMESTAMP NULL COMMENT 'Check-out timestamp',
    break_start_time TIMESTAMP NULL COMMENT 'Break start time',
    break_end_time TIMESTAMP NULL COMMENT 'Break end time',
    total_hours DECIMAL(4,2) DEFAULT 0 COMMENT 'Total working hours',
    overtime_hours DECIMAL(4,2) DEFAULT 0 COMMENT 'Overtime hours',
    status ENUM('present', 'absent', 'late', 'half_day') DEFAULT 'present',
    notes TEXT COMMENT 'Attendance notes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_staff_date (staff_id, work_date),
    INDEX idx_work_date (work_date),
    INDEX idx_status (status),
    
    -- One attendance record per staff per day
    UNIQUE KEY unique_staff_date (staff_id, work_date)
) ENGINE=InnoDB COMMENT='Staff attendance records';
```

---

### 7. Payments Table
Payment transaction records.

```sql
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL COMMENT 'Reference to booking',
    amount DECIMAL(10,2) NOT NULL COMMENT 'Payment amount',
    payment_method ENUM('cash', 'card', 'online', 'bank_transfer') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    transaction_id VARCHAR(100) COMMENT 'External transaction ID',
    gateway_response JSON COMMENT 'Payment gateway response',
    processed_at TIMESTAMP NULL COMMENT 'Payment processing timestamp',
    refunded_at TIMESTAMP NULL COMMENT 'Refund timestamp',
    refund_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Refunded amount',
    notes TEXT COMMENT 'Payment notes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    
    INDEX idx_booking (booking_id),
    INDEX idx_status (payment_status),
    INDEX idx_method (payment_method),
    INDEX idx_transaction (transaction_id),
    INDEX idx_processed_date (processed_at)
) ENGINE=InnoDB COMMENT='Payment transactions';
```

---

### 8. Reviews Table
Customer service reviews and ratings.

```sql
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL COMMENT 'Reference to completed booking',
    client_id INT NOT NULL COMMENT 'Review author',
    staff_id INT NOT NULL COMMENT 'Reviewed staff member',
    service_id INT NOT NULL COMMENT 'Reviewed service',
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5) COMMENT 'Rating 1-5 stars',
    review_text TEXT COMMENT 'Written review',
    is_anonymous BOOLEAN DEFAULT FALSE COMMENT 'Anonymous review flag',
    is_approved BOOLEAN DEFAULT FALSE COMMENT 'Admin approval status',
    response_text TEXT COMMENT 'Staff/admin response',
    responded_at TIMESTAMP NULL COMMENT 'Response timestamp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    
    INDEX idx_booking (booking_id),
    INDEX idx_client (client_id),
    INDEX idx_staff (staff_id),
    INDEX idx_service (service_id),
    INDEX idx_rating (rating),
    INDEX idx_approved (is_approved),
    
    -- One review per booking
    UNIQUE KEY unique_booking_review (booking_id)
) ENGINE=InnoDB COMMENT='Service reviews and ratings';
```

---

### 9. Notifications Table
System notifications for users.

```sql
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT 'Notification recipient',
    type ENUM('booking_confirmation', 'booking_reminder', 'booking_cancelled', 'payment_received', 'review_request', 'system_announcement') NOT NULL,
    title VARCHAR(200) NOT NULL COMMENT 'Notification title',
    message TEXT NOT NULL COMMENT 'Notification content',
    data JSON COMMENT 'Additional notification data',
    is_read BOOLEAN DEFAULT FALSE COMMENT 'Read status',
    read_at TIMESTAMP NULL COMMENT 'Read timestamp',
    sent_via ENUM('in_app', 'email', 'sms', 'push') DEFAULT 'in_app',
    sent_at TIMESTAMP NULL COMMENT 'Sent timestamp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_user (user_id),
    INDEX idx_type (type),
    INDEX idx_read (is_read),
    INDEX idx_sent (sent_at)
) ENGINE=InnoDB COMMENT='User notifications';
```

---

### 10. System Settings Table
Application configuration settings.

```sql
CREATE TABLE system_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL COMMENT 'Setting identifier',
    setting_value TEXT COMMENT 'Setting value',
    setting_type ENUM('string', 'integer', 'boolean', 'json') DEFAULT 'string',
    description TEXT COMMENT 'Setting description',
    is_public BOOLEAN DEFAULT FALSE COMMENT 'Public setting flag',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_key (setting_key),
    INDEX idx_public (is_public)
) ENGINE=InnoDB COMMENT='System configuration settings';
```

**Sample Data:**
```sql
INSERT INTO system_settings VALUES
(1, 'salon_name', 'قصر نور الشمس للجمال', 'string', 'Salon name', 1, NOW(), NOW()),
(2, 'working_hours_start', '09:00', 'string', 'Daily opening time', 1, NOW(), NOW()),
(3, 'working_hours_end', '22:00', 'string', 'Daily closing time', 1, NOW(), NOW()),
(4, 'booking_advance_days', '30', 'integer', 'Maximum days in advance for booking', 1, NOW(), NOW()),
(5, 'cancellation_hours', '24', 'integer', 'Minimum hours before appointment for cancellation', 1, NOW(), NOW());
```

---

## 🔗 Relationships Diagram

```
users (1) ←→ (1) staff_profiles
users (1) ←→ (∞) bookings (as client)
users (1) ←→ (∞) bookings (as staff)
users (1) ←→ (∞) attendance
users (1) ←→ (∞) reviews
users (1) ←→ (∞) notifications

service_categories (1) ←→ (∞) services
services (1) ←→ (∞) bookings

bookings (1) ←→ (∞) payments
bookings (1) ←→ (1) reviews
```

---

## 📊 Indexes and Performance

### Primary Indexes
- All tables have `PRIMARY KEY` on `id` column
- Unique indexes on email, confirmation codes
- Foreign key indexes for referential integrity

### Performance Indexes
```sql
-- Booking queries optimization
CREATE INDEX idx_bookings_date_status ON bookings(appointment_date, status);
CREATE INDEX idx_bookings_staff_date_time ON bookings(staff_id, appointment_date, appointment_time);

-- User search optimization
CREATE INDEX idx_users_name_email ON users(full_name, email);

-- Analytics queries optimization
CREATE INDEX idx_payments_date_status ON payments(processed_at, payment_status);
CREATE INDEX idx_reviews_rating_approved ON reviews(rating, is_approved);
```

---

## 🔒 Security Constraints

### Data Validation Triggers
```sql
-- Prevent booking in the past
DELIMITER $$
CREATE TRIGGER validate_booking_date
    BEFORE INSERT ON bookings
    FOR EACH ROW
BEGIN
    IF NEW.appointment_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot book appointments in the past';
    END IF;
END$$
DELIMITER ;

-- Validate working hours
DELIMITER $$
CREATE TRIGGER validate_working_hours
    BEFORE INSERT ON bookings
    FOR EACH ROW
BEGIN
    IF TIME(NEW.appointment_time) < '09:00:00' OR TIME(NEW.appointment_time) > '22:00:00' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment time outside working hours';
    END IF;
END$$
DELIMITER ;
```

### Row Level Security
```sql
-- Views for role-based access
CREATE VIEW client_bookings AS
SELECT b.*, s.name as service_name, u.full_name as staff_name
FROM bookings b
JOIN services s ON b.service_id = s.id
JOIN users u ON b.staff_id = u.id
WHERE b.client_id = @current_user_id;

CREATE VIEW staff_schedule AS
SELECT b.*, s.name as service_name, u.full_name as client_name
FROM bookings b
JOIN services s ON b.service_id = s.id
JOIN users u ON b.client_id = u.id
WHERE b.staff_id = @current_user_id;
```

---

## 📈 Analytics Views

### Revenue Analytics
```sql
CREATE VIEW monthly_revenue AS
SELECT 
    YEAR(processed_at) as year,
    MONTH(processed_at) as month,
    SUM(amount) as total_revenue,
    COUNT(*) as transaction_count,
    AVG(amount) as average_transaction
FROM payments 
WHERE payment_status = 'completed'
GROUP BY YEAR(processed_at), MONTH(processed_at);
```

### Service Performance
```sql
CREATE VIEW service_analytics AS
SELECT 
    s.id,
    s.name,
    COUNT(b.id) as booking_count,
    AVG(r.rating) as average_rating,
    SUM(p.amount) as total_revenue
FROM services s
LEFT JOIN bookings b ON s.id = b.service_id
LEFT JOIN reviews r ON b.id = r.booking_id
LEFT JOIN payments p ON b.id = p.booking_id AND p.payment_status = 'completed'
GROUP BY s.id, s.name;
```

---

## 🔄 Backup Strategy

### Daily Backup Script
```sql
-- Full backup
mysqldump --single-transaction --routines --triggers \
  --master-data=2 noor_alshams_salon > backup_$(date +%Y%m%d).sql

-- Incremental backup using binary logs
FLUSH LOGS;
```

### Point-in-Time Recovery
```sql
-- Restore from backup
mysql noor_alshams_salon < backup_20240115.sql

-- Apply binary logs for point-in-time recovery
mysqlbinlog --start-datetime="2024-01-15 02:00:00" \
  --stop-datetime="2024-01-15 14:30:00" \
  mysql-bin.000001 | mysql noor_alshams_salon
```

---

*Last Updated: January 15, 2024*  
*Database Version: 1.0*