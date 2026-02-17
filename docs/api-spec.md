# SPARK-PENS API Specification

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Rooms API](#rooms-api)
4. [Bookings API](#bookings-api)
5. [Error Handling](#error-handling)
6. [Postman Collection](#postman-collection)

---

## Overview

**Base URL:** `https://spark-pens-api.onrender.com`

**Authentication:** JWT Bearer Token (except for public endpoints)

**Content Type:** `application/json`

---

## Authentication

### POST /api/auth/login

Login dengan username/email dan password.

**Request:**

```json
{
  "username": "admin",
  "password": "admin"
}
```

**Response (Success):**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "admin@sparkpens.com",
    "name": "Admin",
    "role": "Admin"
  }
}
```

**Response (Error - 401):**

```json
{
  "message": "Invalid credentials"
}
```

---

### POST /api/auth/google

Login dengan Google OAuth (Google ID Token).

**Request:**

```json
{
  "credential": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (Success):**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 2,
    "email": "user@gmail.com",
    "name": "John Doe",
    "role": "User"
  },
  "needsPasswordSetup": false
}
```

---

### POST /api/auth/set-password

Set password untuk user yang login via Google (first time).

**Request:**

```json
{
  "userId": 2,
  "newPassword": "securePassword123"
}
```

**Response (Success):**

```json
{
  "message": "Password set successfully"
}
```

---

### POST /api/auth/forgot-password

Request reset password.

**Request:**

```json
{
  "email": "user@sparkpens.com"
}
```

**Response (Success):**

```json
{
  "message": "Link reset berhasil dibuat",
  "resetLink": "https://spark-pens.vercel.app/reset-password?token=abc123..."
}
```

---

### POST /api/auth/reset-password

Reset password dengan token.

**Request:**

```json
{
  "token": "abc123...",
  "newPassword": "newSecurePassword123"
}
```

**Response (Success):**

```json
{
  "message": "Password reset successfully"
}
```

---

### GET /api/auth/me

Get current user info (requires authentication).

**Headers:**

```
Authorization: Bearer <token>
```

**Response (Success):**

```json
{
  "id": 1,
  "email": "admin@sparkpens.com",
  "name": "Admin",
  "role": "Admin"
}
```

---

## Rooms API

### GET /api/rooms

Get all rooms (public endpoint).

**Response (Success):**

```json
[
  {
    "id": "a1b2c3d4-...",
    "name": "Ruang Meeting A",
    "building": "Gedung A",
    "floor": 1,
    "capacity": 10,
    "description": "Ruang meeting dengan kapasitas 10 orang",
    "isAvailable": true,
    "isDeleted": false,
    "createdDate": "2026-02-14T00:00:00Z"
  },
  {
    "id": "b2c3d4e5-...",
    "name": "Ruang Seminar",
    "building": "Gedung B",
    "floor": 2,
    "capacity": 50,
    "description": "Aula seminar dengan kapasitas 50 orang",
    "isAvailable": true,
    "isDeleted": false,
    "createdDate": "2026-02-14T00:00:00Z"
  }
]
```

---

### POST /api/rooms

Create new room (Admin only).

**Headers:**

```
Authorization: Bearer <token>
```

**Request:**

```json
{
  "name": "Ruang Training",
  "building": "Gedung C",
  "floor": 3,
  "capacity": 20,
  "description": "Ruang training dengan proyektor",
  "isAvailable": true
}
```

**Response (Success - 201):**

```json
{
  "id": "c3d4e5f6-...",
  "name": "Ruang Training",
  "building": "Gedung C",
  "floor": 3,
  "capacity": 20,
  "description": "Ruang training dengan proyektor",
  "isAvailable": true,
  "isDeleted": false,
  "createdDate": "2026-02-17T00:00:00Z"
}
```

---

### PUT /api/rooms/{id}

Update room (Admin only).

**Headers:**

```
Authorization: Bearer <token>
```

**Request:**

```json
{
  "id": "a1b2c3d4-...",
  "name": "Ruang Meeting A - Updated",
  "building": "Gedung A",
  "floor": 1,
  "capacity": 12,
  "description": "Ruang meeting dengan kapasitas 12 orang",
  "isAvailable": true,
  "isDeleted": false,
  "createdDate": "2026-02-14T00:00:00Z"
}
```

**Response (Success - 204):**

```
No Content
```

---

### DELETE /api/rooms/{id}

Delete room (soft delete - Admin only).

**Headers:**

```
Authorization: Bearer <token>
```

**Response (Success):**

```json
{
  "message": "Room deleted successfully"
}
```

---

## Bookings API

### GET /api/bookings

Get all bookings (Admin only).

**Headers:**

```
Authorization: Bearer <token>
```

**Response (Success):**

```json
[
  {
    "id": "b1234567-...",
    "roomId": "a1b2c3d4-...",
    "room": {
      "id": "a1b2c3d4-...",
      "name": "Ruang Meeting A",
      "building": "Gedung A",
      "floor": 1,
      "capacity": 10,
      "description": "...",
      "isAvailable": true
    },
    "requesterName": "John Doe",
    "requesterEmail": "john@example.com",
    "requesterPhone": "081234567890",
    "bookingStartDate": "2026-02-20T09:00:00Z",
    "bookingEndDate": "2026-02-20T11:00:00Z",
    "purpose": "Rapat Team Building",
    "status": "Pending",
    "isDeleted": false,
    "createdDate": "2026-02-17T00:00:00Z"
  }
]
```

---

### GET /api/bookings/room/{roomId}

Get bookings by room (public - for availability check).

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| date | string | Optional date filter (YYYY-MM-DD) |

**Example:** `/api/bookings/room/a1b2c3d4-...?date=2026-02-20`

**Response (Success):**

```json
[
  {
    "id": "b1234567-...",
    "roomId": "a1b2c3d4-...",
    "room": { ... },
    "requesterName": "Jane Doe",
    "requesterEmail": "jane@example.com",
    "bookingStartDate": "2026-02-20T09:00:00Z",
    "bookingEndDate": "2026-02-20T11:00:00Z",
    "purpose": "Interview",
    "status": "Approved"
  }
]
```

---

### POST /api/bookings

Create new booking (public - no auth required).

**Request:**

```json
{
  "roomId": "a1b2c3d4-...",
  "requesterName": "John Doe",
  "requesterEmail": "john@example.com",
  "requesterPhone": "081234567890",
  "bookingStartDate": "2026-02-20T09:00:00Z",
  "bookingEndDate": "2026-02-20T11:00:00Z",
  "purpose": "Rapat Team Building"
}
```

**Response (Success - 201):**

```json
{
  "id": "b1234567-...",
  "roomId": "a1b2c3d4-...",
  "requesterName": "John Doe",
  "requesterEmail": "john@example.com",
  "requesterPhone": "081234567890",
  "bookingStartDate": "2026-02-20T09:00:00Z",
  "bookingEndDate": "2026-02-20T11:00:00Z",
  "purpose": "Rapat Team Building",
  "status": "Pending",
  "createdDate": "2026-02-17T12:00:00Z"
}
```

**Response (Error - 400 - Overlap):**

```json
{
  "message": "Ruangan sudah dipinjam pada waktu tersebut!",
  "conflicts": [
    {
      "bookingStartDate": "2026-02-20T10:00:00Z",
      "bookingEndDate": "2026-02-20T12:00:00Z",
      "requesterName": "Jane Doe",
      "status": "Pending"
    }
  ]
}
```

---

### PATCH /api/bookings/{id}/status

Update booking status (Admin only).

**Headers:**

```
Authorization: Bearer <token>
```

**Request:**

```json
{
  "status": "Approved",
  "rejectionReason": null
}
```

**Response (Success):**

```json
{
  "message": "Status berhasil diubah menjadi Approved",
  "data": {
    "id": "b1234567-...",
    "roomId": "a1b2c3d4-...",
    "status": "Approved",
    ...
  }
}
```

**Valid Status Values:**

- `Pending`
- `Approved`
- `Rejected`

---

### DELETE /api/bookings/{id}

Delete booking (Admin only).

**Headers:**

```
Authorization: Bearer <token>
```

**Response (Success):**

```json
{
  "message": "Booking berhasil dihapus"
}
```

---

## Error Handling

### Error Response Format

```json
{
  "message": "Error description"
}
```

### HTTP Status Codes

| Code | Description           |
| ---- | --------------------- |
| 200  | Success               |
| 201  | Created               |
| 204  | No Content            |
| 400  | Bad Request           |
| 401  | Unauthorized          |
| 403  | Forbidden             |
| 404  | Not Found             |
| 500  | Internal Server Error |

### Common Errors

**400 - Validation Error:**

```json
{
  "message": "Ruangan tidak ditemukan."
}
```

**401 - Unauthorized:**

```json
{
  "message": "Invalid credentials"
}
```

**404 - Not Found:**

```json
{
  "message": "Booking tidak ditemukan."
}
```

---

## Postman Collection

### Import Instructions

1. Open Postman
2. Click "Import" button
3. Select "Link" tab
4. Enter the raw URL of the JSON file
5. Click "Continue"
6. The collection will be imported

### Manual Import

You can also import the collection file directly:

- File: [spark-pens.postman_collection.json](../api-testing/spark-pens.postman_collection.json)

### Environment Variables

Create a new environment in Postman with these variables:

| Variable  | Initial Value                       |
| --------- | ----------------------------------- |
| `baseUrl` | https://spark-pens-api.onrender.com |
| `token`   | (empty - will be set after login)   |

### Collection Structure

```
SPARK-PENS API
├── Auth
│   ├── Login (Admin)
│   ├── Login (Google)
│   ├── Get Current User
│   ├── Forgot Password
│   ├── Reset Password
│   └── Set Password
├── Rooms
│   ├── Get All Rooms
│   ├── Create Room
│   ├── Update Room
│   └── Delete Room
└── Bookings
    ├── Get All Bookings
    ├── Get Bookings By Room
    ├── Create Booking
    ├── Update Booking Status
    └── Delete Booking
```

### Testing the API

1. **Login as Admin:**
   - Send POST to `{{baseUrl}}/api/auth/login`
   - Body: `{"username": "admin", "password": "admin"}`
   - Copy the `token` from response to environment variable

2. **Test Authenticated Endpoints:**
   - Add `Authorization: Bearer {{token}}` header
   - Test room creation, booking management, etc.

3. **Test Public Endpoints:**
   - No auth header required
   - Test room listing, booking creation

---

## Swagger / OpenAPI

For interactive API documentation, visit:

- **URL:** https://spark-pens-api.onrender.com/swagger

The Swagger UI provides:

- Interactive API testing
- Request/Response schemas
- Model definitions
- Authentication support

---

## Rate Limiting

Currently, no rate limiting is implemented. For production, consider:

- API Gateway (Render Pro)
- Nginx rate limiting
- Application-level throttling

---

## Versioning

Current API Version: **v1**

The API is versioned via URL path: `/api/v1/...`

Future versions will be available at:

- `/api/v2/...`
- etc.

---

## Support

For API issues or questions:

- Check the Swagger documentation
- Review this API spec
- Contact the development team
