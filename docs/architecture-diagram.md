# Arsitektur Sistem SPARK-PENS

## Gambaran Umum

SPARK-PENS adalah sistem peminjaman ruangan berbasis web yang dibangun untuk Politeknik Elektronika Negeri Surabaya (PENS). Sistem ini memungkinkan mahasiswa, dosen, dan admin untuk memesan ruangan secara online.

## Mermaid Diagrams

Anda dapat melihat diagram ini secara interaktif di: https://mermaid.live

### 1. Arsitektur Sistem Keseluruhan

```mermaid
flowchart TB
    subgraph Users["Pengguna / Users"]
        Mhs["Mahasiswa"]
        Dosen["Dosen"]
        Admin["Admin"]
    end

    subgraph Frontend["FRONTEND (Vercel - React)"]
        direction TB
        Login["Login Page"]
        Room["Room Page"]
        Booking["Booking Page"]
        AdminDash["Admin Dashboard"]
    end

    subgraph Backend["BACKEND (Render - ASP.NET Core)"]
        direction TB
        Auth["Auth Controller"]
        Rooms["Rooms Controller"]
        Bookings["Bookings Controller"]
        JWT["JWT Middleware"]
    end

    subgraph Database["DATABASE (Neon PostgreSQL)"]
        UsersDB["Users Table"]
        RoomsDB["Rooms Table"]
        BookingsDB["Bookings Table"]
    end

    Users --> Frontend
    Mhs --> Room
    Mhs --> Booking
    Dosen --> Room
    Dosen --> Booking
    Admin --> AdminDash

    Frontend -->|"REST API"| Backend
    Backend -->|"PostgreSQL"| Database

    RoomsDB --> BookingsDB
```

### 2. Flowchart Login

```mermaid
flowchart TD
    Start["User Membuka Halaman Login"] --> ChooseLogin{ Pilih Metode Login }

    ChooseLogin -->|"Username/Password"| CredLogin[Input Username & Password]
    ChooseLogin -->|"Google OAuth"| GoogleLogin[Login dengan Google]

    CredLogin --> Validate1["Validasi Credentials"]
    GoogleLogin --> Validate2["Validasi Google Token"]

    Validate1 --> CheckDB{Cek Database}
    Validate2 --> CheckDB

    CheckDB -->|Valid| GenerateJWT[Generate JWT Token]
    CheckDB -->|Invalid| Error1["Tampilkan Error"]

    GenerateJWT --> StoreToken["Simpan Token di localStorage"]
    StoreToken --> Redirect["Redirect ke Dashboard"]

    Error1 --> ChooseLogin

    Redirect --> CheckRole{Cek Role User}

    CheckRole -->|Admin| AdminPage["Redirect ke Admin Dashboard"]
    CheckRole -->|User| UserPage["Redirect ke User Dashboard"]
```

### 3. Flowchart Peminjaman Ruangan

```mermaid
flowchart TD
    Start["User Pilih Ruangan"] --> SelectRoom[Pilih Ruangan]
    SelectRoom --> SelectDate[Pilih Tanggal]
    SelectDate --> SelectTime[Pilih Jam Mulai & Selesai]

    SelectTime --> Submit["Submit Booking Request"]
    Submit --> APICall["POST /api/bookings"]

    APICall --> CheckOverlap{Cek Overlap}

    CheckOverlap -->|Tidak Ada Overlap| SaveDB["Simpan ke Database"]
    CheckOverlap -->|Ada Overlap| ErrorOverlap["Tampilkan Error: Ruangan Sudah Dipesan"]

    SaveDB --> SetPending["Set Status = Pending"]
    SetPending --> Success["Tampilkan Success Message"]
    Success --> Notify["Kirim Notifikasi ke Admin"]
    Notify --> End

    ErrorOverlap --> FixTime["User Pilih Waktu Lain"]
    FixTime --> SelectTime
```

### 4. Flowchart Persetujuan Admin

```mermaid
flowchart TD
    Start["Admin Login"] --> ViewBookings["Lihat Daftar Booking"]
    ViewBookings --> SelectBooking{Pilih Booking}

    SelectBooking --> Approve["Klik Approve"]
    SelectBooking --> Reject["Klik Reject"]

    Approve --> UpdateStatus1["Update Status = Approved"]
    Reject --> UpdateStatus2["Update Status = Rejected"]

    UpdateStatus1 --> Save1["Simpan ke Database"]
    UpdateStatus2 --> Save2["Simpan ke Database"]

    Save1 --> NotifyUser1["Kirim Notifikasi ke User"]
    Save2 --> NotifyUser2["Kirim Notifikasi ke User"]

    NotifyUser1 --> Refresh["Refresh Halaman"]
    NotifyUser2 --> Refresh

    Refresh --> ViewBookings
```

### 5. Entity Relationship Diagram

```mermaid
erDiagram
    USERS ||--o{ BOOKINGS : "makes"
    ROOMS ||--o{ BOOKINGS : "has"

    USERS {
        int id PK
        string email
        string name
        string role
        string googleId
        string passwordHash
        bool hasPassword
        string resetToken
        datetime resetExpiry
        datetime createdAt
    }

    ROOMS {
        uuid id PK
        string name
        string building
        int floor
        int capacity
        string description
        bool isAvailable
        bool isDeleted
        datetime createdDate
    }

    BOOKINGS {
        uuid id PK
        uuid roomId FK
        string requesterName
        string requesterEmail
        string requesterPhone
        datetime bookingStartDate
        datetime bookingEndDate
        string purpose
        string status
        bool isDeleted
        datetime createdDate
    }
```

### 6. Arsitektur Components (Class Diagram)

```mermaid
classDiagram
    class User {
        +int Id
        +string Email
        +string Name
        +string Role
        +string GoogleId
        +string PasswordHash
        +bool HasPassword
        +string ResetToken
        +DateTime ResetExpiry
        +DateTime CreatedAt
    }

    class Room {
        +Guid Id
        +string Name
        +string Building
        +int Floor
        +int Capacity
        +string Description
        +bool IsAvailable
        +bool IsDeleted
        +DateTime CreatedDate
    }

    class Booking {
        +Guid Id
        +Guid RoomId
        +string RequesterName
        +string RequesterEmail
        +string RequesterPhone
        +DateTime BookingStartDate
        +DateTime BookingEndDate
        +string Purpose
        +string Status
        +bool IsDeleted
        +DateTime CreatedDate
    }

    class AuthController {
        +Login()
        +GoogleLogin()
        +SetPassword()
        +ForgotPassword()
        +ResetPassword()
        +GetCurrentUser()
    }

    class RoomsController {
        +GetRooms()
        +PostRoom()
        +PutRoom()
        +DeleteRoom()
    }

    class BookingsController {
        +GetBookings()
        +GetBookingsByRoom()
        +CreateBooking()
        +UpdateStatus()
        +DeleteBooking()
    }

    User <|-- AuthController
    Room <|-- RoomsController
    Booking <|-- BookingsController
    Room --o Booking : "RoomId"
    User --o Booking : "RequesterEmail"
```

### 7. Sequence Diagram - Create Booking

```mermaid
sequenceDiagram
    participant U as User
    participant F as Frontend
    participant B as Backend
    participant D as Database

    U->>F: Pilih Ruangan & Waktu
    F->>B: POST /api/bookings
    B->>D: Cek overlapping bookings
    D-->>B: Result: No overlap

    B->>D: INSERT new Booking
    D-->>B: Booking Created

    B-->>F: 201 Created
    F-->>U: Tampilkan Success Message

    Note over B,D: Status = "Pending"
    Note over B: Admin akan menerima notifikasi
```

### 8. Deployment Architecture

```mermaid
flowchart LR
    subgraph Cloud["Cloud Providers"]
        Vercel["Vercel<br/>(Frontend)"]
        Render["Render<br/>(Backend)"]
        Neon["Neon<br/>(Database)"]
    end

    subgraph Users["End Users"]
        Browser["Browser"]
        Mobile["Mobile"]
    end

    Browser -->|"HTTPS"| Vercel
    Mobile -->|"HTTPS"| Vercel

    Vercel -->|"REST API"| Render
    Render -->|"PostgreSQL"| Neon

    style Vercel fill:#000,color:#fff
    style Render fill:#4695d3,color:#fff
    style Neon fill:#1a4c7c,color:#fff
```

### 9. API Endpoints Overview

```mermaid
flowchart TB
    subgraph API["SPARK-PENS API"]
        subgraph AuthAPI["Auth Endpoints"]
            A1["POST /api/auth/login"]
            A2["POST /api/auth/google"]
            A3["POST /api/auth/set-password"]
            A4["POST /api/auth/forgot-password"]
            A5["POST /api/auth/reset-password"]
            A6["GET /api/auth/me"]
        end

        subgraph RoomsAPI["Rooms Endpoints"]
            R1["GET /api/rooms"]
            R2["POST /api/rooms"]
            R3["PUT /api/rooms/{id}"]
            R4["DELETE /api/rooms/{id}"]
        end

        subgraph BookingsAPI["Bookings Endpoints"]
            B1["GET /api/bookings"]
            B2["GET /api/bookings/room/{id}"]
            B3["POST /api/bookings"]
            B4["PATCH /api/bookings/{id}/status"]
            B5["DELETE /api/bookings/{id}"]
        end
    end

    Public["Public"] -.-> R1
    Public -.-> B2
    Public -.-> B3
    Public -.-> A1
    Public -.-> A2

    Auth["Authenticated"] -.-> R2
    Auth -.-> R3
    Auth -.-> R4
    Auth -.-> B1
    Auth -.-> B4
    Auth -.-> B5
    Auth -.-> A6

    style Public fill:#90EE90
    style Auth fill:#FFB6C1
```

## Cara Melihat Diagram

1. **Online (Mermaid Live):**
   - Buka https://mermaid.live
   - Copy kode Mermaid dari file ini
   - Paste di editor kiri
   - Diagram akan di-render secara otomatis

2. **VS Code:**
   - Install extension "Markdown Preview Mermaid Support"
   - Buka file ini di VS Code
   - Klik "Preview" untuk melihat diagram

3. **GitHub/GitLab:**
   - Kedua platform mendukung Mermaid di Markdown
   - Diagram akan di-render otomatis di README

## Link Referensi

- [Mermaid Live Editor](https://mermaid.live)
- [Mermaid Documentation](https://mermaid.js.org/intro/)
- [Mermaid Cheat Sheet](https://mermaid.js.org/intro/cheat-sheet.html)
