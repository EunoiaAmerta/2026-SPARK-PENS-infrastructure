# 🚀 SPARK-PENS Infrastructure

> Sistem Peminjaman Ruangan (Room Booking System) untuk PENS (Politeknik Elektronika Negeri Surabaya)

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![Status](https://img.shields.io/badge/status-Active-green.svg)](#)

## 📋 Daftar Isi

1. [Arsitektur Sistem](#-arsitektur-sistem)
2. [Teknologi yang Digunakan](#-teknologi-yang-digunakan)
3. [Link Produksi](#-link-produksi)
4. [Daftar Endpoint API](#-daftar-endpoint-api)
5. [Environment Variables](#-environment-variables)
6. [Struktur Database](#-struktur-database)
7. [Cara Setup](#-cara-setup)
8. [Dokumentasi Tambahan](#-dokumentasi-tambahan)

---

## 🏗️ Arsitektur Sistem

> **Catatan:** Diagram lengkap tersedia dalam format Mermaid yang dapat dilihat di:
>
> - **[Mermaid Live](https://mermaid.live)**: Copy-paste kode dari [`docs/architecture-diagram.md`](./docs/architecture-diagram.md)
> - **GitHub/VS Code**: Diagram akan di-render otomatis di Markdown

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SPARK-PENS ARCHITECTURE                        │
└─────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────────┐
                              │     USER / DOSEN    │
                              └──────────┬──────────┘
                                         │
                                         ▼
                         ┌───────────────────────────────┐
                         │         FRONTEND              │
                         │      (Vercel - React)         │
                         │                               │
                         │  • Login/Register Page        │
                         │  • Room Booking Page         │
                         │  • Admin Dashboard           │
                         │  • Dark/Light Theme          │
                         └──────────────┬──────────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    │                   │                   │
                    ▼                   ▼                   ▼
         ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
         │   MAHASISWA      │  │     ADMIN        │  │     DOSEN        │
         │                  │  │                  │  │                  │
         │ • View Rooms     │  │ • Manage Rooms   │  │ • View Rooms     │
         │ • Book Room     │  │ • Approve/Reject │  │ • Book Room      │
         │ • My Bookings   │  │ • View Reports   │  │ • My Bookings    │
         └──────────────────┘  └──────────────────┘  └──────────────────┘
                    │                   │                   │
                    └───────────────────┼───────────────────┘
                                        │
                                        ▼
                         ┌───────────────────────────────┐
                         │          BACKEND               │
                         │    (Render - ASP.NET Core)    │
                         │                               │
                         │  • RESTful API                │
                         │  • JWT Authentication         │
                         │  • Google OAuth 2.0           │
                         │  • Role-based Access          │
                         └──────────────┬──────────────┘
                                        │
                                        ▼
                         ┌───────────────────────────────┐
                         │         DATABASE               │
                         │   (Neon - PostgreSQL)         │
                         │                               │
                         │  • Users Table                │
                         │  • Rooms Table                │
                         │  • Bookings Table            │
                         └───────────────────────────────┘
```

### Alur Data:

1. **User** mengakses Frontend melalui browser
2. **Frontend** melakukan request ke Backend API
3. **Backend** memproses request dan menyimpan data ke **Database**
4. **Response** dikembalikan ke Frontend untuk ditampilkan ke user

---

## 💻 Teknologi yang Digunakan

| Komponen             | Teknologi                 | Provider |
| -------------------- | ------------------------- | -------- |
| **Frontend**         | React + TypeScript + Vite | Vercel   |
| **Backend**          | ASP.NET Core 10.0         | Render   |
| **Database**         | PostgreSQL                | Neon     |
| **Authentication**   | JWT + Google OAuth 2.0    | -        |
| **Password Hashing** | BCrypt                    | -        |

---

## 🔗 Link Produksi

| Service                   | URL                                                                                        | Keterangan          |
| ------------------------- | ------------------------------------------------------------------------------------------ | ------------------- |
| **Frontend (Production)** | [https://spark-pens.vercel.app](https://spark-pens.vercel.app)                             | Aplikasi utama      |
| **Backend API**           | [https://spark-pens-api.onrender.com](https://spark-pens-api.onrender.com)                 | REST API            |
| **Swagger Documentation** | [https://spark-pens-api.onrender.com/swagger](https://spark-pens-api.onrender.com/swagger) | API Documentation   |
| **Database Console**      | [Neon Console](https://console.neon.tech)                                                  | Database Management |

---

## 📡 Daftar Endpoint API

### 🔐 Authentication Endpoints

| Method | Endpoint                    | Description                    | Auth Required |
| ------ | --------------------------- | ------------------------------ | ------------- |
| POST   | `/api/auth/login`           | Login dengan username/password | ❌            |
| POST   | `/api/auth/google`          | Login dengan Google OAuth      | ❌            |
| POST   | `/api/auth/set-password`    | Set password (Google user)     | ❌            |
| POST   | `/api/auth/forgot-password` | Request reset password         | ❌            |
| POST   | `/api/auth/reset-password`  | Reset password dengan token    | ❌            |
| GET    | `/api/auth/me`              | Get current user info          | ✅            |

### 🏠 Room Endpoints

| Method | Endpoint          | Description               | Auth Required |
| ------ | ----------------- | ------------------------- | ------------- |
| GET    | `/api/rooms`      | Get all rooms             | ❌            |
| POST   | `/api/rooms`      | Create new room           | ✅ (Admin)    |
| PUT    | `/api/rooms/{id}` | Update room               | ✅ (Admin)    |
| DELETE | `/api/rooms/{id}` | Delete room (soft delete) | ✅ (Admin)    |

### 📅 Booking Endpoints

| Method | Endpoint                      | Description              | Auth Required |
| ------ | ----------------------------- | ------------------------ | ------------- |
| GET    | `/api/bookings`               | Get all bookings (Admin) | ✅ (Admin)    |
| GET    | `/api/bookings/room/{roomId}` | Get bookings by room     | ❌            |
| POST   | `/api/bookings`               | Create new booking       | ❌            |
| PATCH  | `/api/bookings/{id}/status`   | Update booking status    | ✅ (Admin)    |
| DELETE | `/api/bookings/{id}`          | Delete booking           | ✅ (Admin)    |

---

## 🔑 Environment Variables

### Backend (appsettings.json / Render Environment)

```bash
# Connection String untuk Database Neon PostgreSQL
ConnectionStrings__DefaultConnection=Host=your-neon-host;Database=neondb;Username=your-username;Password=your-password;SSL Mode=Require;Trust Server Certificate=true

# JWT Configuration
Jwt__Key=SparkPensSecretKey12345678901234567890
Jwt__Issuer=SparkPens
Jwt__Audience=SparkPensUsers

# Google OAuth (Opsional)
Google__ClientId=your-google-client-id.apps.googleusercontent.com

# Frontend URL (untuk CORS dan reset password)
FrontendUrl=https://spark-pens.vercel.app
```

### Frontend (.env)

```bash
# API Base URL
VITE_API_URL=https://spark-pens-api.onrender.com

# Google OAuth Client ID
VITE_GOOGLE_CLIENT_ID=886176078344-jimop9ec8htg2cvuuijvgluuevggmlatT_ID.apps.googleusercontent.com
```

---

## 🗄️ Struktur Database

### Entity Relationship Diagram (Text)

```
┌─────────────────┐       ┌─────────────────┐
│     Users       │       │     Rooms       │
├─────────────────┤       ├─────────────────┤
│ Id (PK)         │       │ Id (PK)         │
│ Email           │       │ Name            │
│ Name            │       │ Building        │
│ Role            │◄──────│ Floor           │
│ GoogleId        │       │ Capacity        │
│ PasswordHash    │       │ Description     │
│ HasPassword     │       │ IsAvailable     │
│ ResetToken      │       │ IsDeleted       │
│ ResetExpiry     │       │ CreatedDate     │
│ CreatedAt       │       └────────┬────────┘
└────────┬────────┘                │
         │                          │
         │                         │
         │    ┌────────────────────┘
         │    │
         ▼    ▼
┌─────────────────┐
│    Bookings     │
├─────────────────┤
│ Id (PK)         │
│ RoomId (FK)     │────► Rooms
│ RequesterName   │
│ RequesterEmail │
│ RequesterPhone  │
│ BookingStartDate│
│ BookingEndDate  │
│ Purpose         │
│ Status          │
│ IsDeleted       │
│ CreatedDate     │
└─────────────────┘
```

### Tabel Detail

#### 1. Users Table

```sql
CREATE TABLE "Users" (
    "Id" SERIAL PRIMARY KEY,
    "Email" VARCHAR(255) NOT NULL,
    "Name" VARCHAR(255) NOT NULL,
    "Role" VARCHAR(50) NOT NULL DEFAULT 'User',  -- 'Admin' or 'User'
    "GoogleId" VARCHAR(255),
    "PasswordHash" VARCHAR(255),
    "HasPassword" BOOLEAN DEFAULT FALSE,
    "ResetToken" VARCHAR(255),
    "ResetExpiry" TIMESTAMP WITH TIME ZONE,
    "CreatedAt" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 2. Rooms Table

```sql
CREATE TABLE "Rooms" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Name" VARCHAR(100) NOT NULL,
    "Building" VARCHAR(100) NOT NULL,
    "Floor" INTEGER NOT NULL,
    "Capacity" INTEGER NOT NULL,
    "Description" TEXT NOT NULL,
    "IsAvailable" BOOLEAN DEFAULT TRUE,
    "IsDeleted" BOOLEAN DEFAULT FALSE,
    "CreatedDate" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 3. Bookings Table

```sql
CREATE TABLE "Bookings" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "RoomId" UUID NOT NULL REFERENCES "Rooms"("Id"),
    "RequesterName" VARCHAR(100) NOT NULL,
    "RequesterEmail" VARCHAR(255) NOT NULL,
    "RequesterPhone" TEXT,
    "BookingStartDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "BookingEndDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    "Purpose" TEXT NOT NULL,
    "Status" TEXT DEFAULT 'Pending',  -- 'Pending', 'Approved', 'Rejected'
    "IsDeleted" BOOLEAN DEFAULT FALSE,
    "CreatedDate" TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## ⚙️ Cara Setup

### Prerequisites

- Node.js 18+
- .NET 10.0 SDK
- PostgreSQL (untuk development lokal)
- Docker (opsional)

### Development Lokal

#### 1. Clone Repository

```bash
git clone https://github.com/your-repo/SPARK-PENS-PROJECT.git
cd SPARK-PENS-PROJECT
```

#### 2. Setup Backend

```bash
cd 2026-SPARK-PENS-backend

# Restore dependencies
dotnet restore

# Setup database (Gunakan Docker Compose)
docker-compose up -d db

# Run migrations
dotnet ef database update

# Run backend
dotnet run
```

Backend akan berjalan di: `http://localhost:5000`

#### 3. Setup Frontend

```bash
cd 2026-SPARK-PENS-frontend

# Install dependencies
npm install

# Run frontend
npm run dev
```

Frontend akan berjalan di: `http://localhost:5173`

### Menggunakan Docker Compose (All-in-One)

```bash
# Jalankan seluruh ekosistem (DB + Backend + Frontend)
docker-compose up -d
```

Lihat [docker-compose.yml](./docker-compose.yml) untuk detail lengkap.

### Deploy ke Production

#### Backend ke Render:

1. Push code ke GitHub
2. Hubungkan repository ke Render
3. Set environment variables:
   - `ConnectionStrings__DefaultConnection`
   - `Jwt__Key`
   - `Jwt__Issuer`
   - `Jwt__Audience`
4. Build command: `dotnet build`
5. Start command: `dotnet SparkPens.Api.dll`

#### Frontend ke Vercel:

1. Push code ke GitHub
2. Import project di Vercel
3. Set environment variables:
   - `VITE_API_URL`
   - `VITE_GOOGLE_CLIENT_ID`
4. Deploy otomatis akan berjalan

---

## 📚 Dokumentasi Tambahan

| File                                                                                                 | Deskripsi                                              |
| ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| [./docs/architecture-diagram.md](./docs/architecture-diagram.md)                                     | Diagram arsitektur sistem yang lebih detail            |
| [./docs/api-spec.md](./docs/api-spec.md)                                                             | Spesifikasi API lengkap dengan contoh request/response |
| [./database/schema.sql](./database/schema.sql)                                                       | Skema database lengkap                                 |
| [./database/seed-admin.sql](./database/seed-admin.sql)                                               | Script untuk membuat admin user                        |
| [./api-testing/spark-pens.postman_collection.json](./api-testing/spark-pens.postman_collection.json) | Koleksi API untuk Postman                              |

---

## 👥 Default Credentials

### Admin Account (Auto-Created)

```
Username: admin
Password: admin
```

> **Catatan:** Akun admin akan dibuat otomatis saat pertama kali login dengan kredensial di atas.

### Google OAuth

- Email harus diverifikasi oleh Google
- Akun Google akan otomatis dibuat sebagai user dengan role "User"

---

## 📄 Lisensi

Project ini menggunakan lisensi MIT. Lihat file [LICENSE](./LICENSE) untuk detail.

---

## 🤝 Kontribusi

Silakan buat pull request atau hubungi tim pengembang untuk kontribusi.

---

**Dibuat dengan ❤️ oleh Tim SPARK-PENS 2026**
