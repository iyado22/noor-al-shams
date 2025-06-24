# 📚 API Documentation - Noor Al-Shams Beauty Salon

## 🔗 Base Information

**Base URL:** `https://api.nooralshamssalon.com/v1`  
**Authentication:** Bearer Token (JWT)  
**Content-Type:** `application/json`  
**Rate Limiting:** 1000 requests/hour per user  

---

## 🔐 Authentication

### Login
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "تم تسجيل الدخول بنجاح",
  "data": {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_in": 3600,
    "user": {
      "id": 123,
      "full_name": "سارة أحمد",
      "email": "sara@example.com",
      "role": "client"
    }
  }
}
```

### Register
```http
POST /auth/register
```

**Request Body:**
```json
{
  "full_name": "سارة أحمد",
  "email": "sara@example.com",
  "password": "SecurePass123!",
  "phone": "+966501234567",
  "date_of_birth": "1990-05-15"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "message": "تم إنشاء الحساب بنجاح. يرجى التحقق من بريدك الإلكتروني",
  "data": {
    "user_id": 123,
    "verification_required": true
  }
}
```

---

## 👥 User Management

### Get User Profile
```http
GET /users/{id}
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "id": 123,
    "full_name": "سارة أحمد",
    "email": "sara@example.com",
    "phone": "+966501234567",
    "date_of_birth": "1990-05-15",
    "role": "client",
    "is_active": true,
    "email_verified_at": "2024-01-15T10:30:00Z",
    "created_at": "2024-01-10T08:00:00Z"
  }
}
```

### Update User Profile
```http
PUT /users/{id}
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "full_name": "سارة أحمد محمد",
  "phone": "+966501234568"
}
```

---

## 🛍️ Services Management

### Get All Services
```http
GET /services
```

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `category` (optional): Filter by category
- `active` (optional): Filter by active status

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "services": [
      {
        "id": 1,
        "name": "قص شعر",
        "description": "قص شعر عادي بأحدث الطرق",
        "price": 50.00,
        "duration": 30,
        "category": "hair_care",
        "is_active": true,
        "image_url": "https://example.com/images/haircut.jpg"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 45,
      "items_per_page": 10
    }
  }
}
```

### Create Service (Admin Only)
```http
POST /services
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "تنظيف بشرة",
  "description": "تنظيف عميق للبشرة بأحدث التقنيات",
  "price": 120.00,
  "duration": 60,
  "category": "skin_care"
}
```

---

## 📅 Booking Management

### Get User Bookings
```http
GET /bookings
Authorization: Bearer {token}
```

**Query Parameters:**
- `status` (optional): Filter by booking status
- `date_from` (optional): Start date filter
- `date_to` (optional): End date filter

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "bookings": [
      {
        "id": 456,
        "service": {
          "id": 1,
          "name": "قص شعر",
          "price": 50.00,
          "duration": 30
        },
        "staff": {
          "id": 2,
          "name": "نور محمد",
          "specialization": "خبيرة شعر"
        },
        "appointment_date": "2024-02-15",
        "appointment_time": "10:00:00",
        "status": "confirmed",
        "total_amount": 50.00,
        "confirmation_code": "NS2024-456",
        "notes": "أول زيارة للصالون",
        "created_at": "2024-01-15T09:00:00Z"
      }
    ]
  }
}
```

### Create Booking
```http
POST /bookings
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "service_id": 1,
  "staff_id": 2,
  "appointment_date": "2024-02-15",
  "appointment_time": "10:00",
  "notes": "أول زيارة للصالون"
}
```

**Response (201 Created):**
```json
{
  "status": "success",
  "message": "تم حجز الموعد بنجاح",
  "data": {
    "booking_id": 456,
    "confirmation_code": "NS2024-456",
    "status": "pending",
    "total_amount": 50.00,
    "appointment_date": "2024-02-15",
    "appointment_time": "10:00:00"
  }
}
```

### Update Booking Status (Staff/Admin)
```http
PATCH /bookings/{id}/status
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "status": "completed",
  "notes": "تم إنجاز الخدمة بنجاح"
}
```

---

## 👨‍💼 Staff Management

### Get Staff List
```http
GET /staff
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "staff": [
      {
        "id": 2,
        "full_name": "نور محمد",
        "specialization": "خبيرة شعر",
        "experience_years": 5,
        "bio": "خبيرة في قص وصبغ الشعر",
        "is_available": true,
        "working_hours": {
          "saturday": {"start": "09:00", "end": "17:00"},
          "sunday": {"start": "09:00", "end": "17:00"}
        }
      }
    ]
  }
}
```

### Staff Check-in
```http
POST /staff/{id}/checkin
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "message": "تم تسجيل الحضور بنجاح",
  "data": {
    "check_in_time": "2024-01-15T09:00:00Z",
    "work_date": "2024-01-15"
  }
}
```

### Get Staff Schedule
```http
GET /staff/{id}/schedule
Authorization: Bearer {token}
```

**Query Parameters:**
- `date_from` (optional): Start date
- `date_to` (optional): End date

---

## 📊 Analytics (Admin Only)

### Dashboard Analytics
```http
GET /analytics/dashboard
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "status": "success",
  "data": {
    "overview": {
      "total_clients": 1250,
      "total_bookings": 3450,
      "monthly_revenue": 125000.00,
      "active_staff": 15
    },
    "recent_bookings": [
      {
        "id": 456,
        "client_name": "سارة أحمد",
        "service_name": "قص شعر",
        "appointment_date": "2024-01-15",
        "status": "confirmed"
      }
    ],
    "revenue_chart": [
      {"month": "يناير", "revenue": 45000},
      {"month": "فبراير", "revenue": 52000}
    ]
  }
}
```

---

## ❌ Error Responses

### Validation Error (422)
```json
{
  "status": "error",
  "error_code": "VALIDATION_FAILED",
  "message": "البيانات المدخلة غير صحيحة",
  "details": {
    "email": ["البريد الإلكتروني مطلوب"],
    "password": ["كلمة المرور يجب أن تكون 8 أحرف على الأقل"]
  },
  "timestamp": "2024-01-15T10:30:00Z",
  "request_id": "req_123456789"
}
```

### Authentication Error (401)
```json
{
  "status": "error",
  "error_code": "UNAUTHORIZED",
  "message": "غير مصرح لك بالوصول",
  "timestamp": "2024-01-15T10:30:00Z",
  "request_id": "req_123456789"
}
```

### Not Found Error (404)
```json
{
  "status": "error",
  "error_code": "NOT_FOUND",
  "message": "المورد غير موجود",
  "timestamp": "2024-01-15T10:30:00Z",
  "request_id": "req_123456789"
}
```

---

## 🔒 Security Headers

All API responses include security headers:
```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
```

---

## 📝 Rate Limiting

Rate limits are applied per user:
- **Standard Users:** 1000 requests/hour
- **Premium Users:** 5000 requests/hour
- **Admin Users:** 10000 requests/hour

Rate limit headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1642248000
```

---

## 🌐 API Versioning

Current version: `v1`
- All endpoints are prefixed with `/v1`
- Backward compatibility maintained for 6 months
- New versions announced 3 months in advance

---

*Last Updated: January 15, 2024*