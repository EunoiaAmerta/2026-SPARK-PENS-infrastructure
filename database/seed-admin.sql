-- =============================================================================
-- SPARK-PENS Seed Data - Admin User
-- =============================================================================
--
-- IMPORTANT NOTE / CATATAN PENTING:
-- =====================================
-- Anda TIDAK PERLU menjalankan SQL ini secara manual!
-- Cukup login dengan username "admin" dan password "admin" di halaman login,
-- dan sistem akan otomatis membuat akun admin untuk Anda.
--
-- SQL ini hanya sebagai BACKUP jika auto-creation tidak bekerja
-- atau jika Anda ingin membuat admin user secara manual di database.
-- =============================================================================

-- Catatan: Password "admin" sudah di-hash dengan BCrypt (cost factor 12)
-- Hash: $2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQ3Z9x9Wq
--
-- Anda bisa generate hash baru dengan:
-- BCrypt.HashPassword("your-password", 12)

-- =============================================================================
-- CARA PENGGUNAAN / HOW TO USE:
-- =============================================================================
--
-- Opsi 1: Jika admin tidak bisa login, jalankan SQL ini untuk reset:
-- =============================================================================
-- 1. Hapus user admin yang lama (jika ada):
--    DELETE FROM "Users" WHERE "Role" = 'Admin';
--
-- 2. Jalankan INSERT di bawah ini untuk membuat admin baru:
--    (Lihat script INSERT di bawah)
--
-- =============================================================================
-- Opsi 2: Langsung insert (Jika database sudah ada):
-- =============================================================================

-- Cara 1: Insert admin user langsung (tanpa perlu login dulu)
-- =============================================================================

-- Pertama, cek apakah sudah ada admin
SELECT "Id", "Email", "Name", "Role", "CreatedAt" 
FROM "Users" 
WHERE "Role" = 'Admin';

-- Jika belum ada admin, jalankan INSERT ini:
-- =============================================================================
-- UNCOMMENT BARIS DI BAWAH INI JIKA ANDA INGIN MENAMBAHKAN ADMIN USER
-- =============================================================================
/*
INSERT INTO "Users" (
    "Email", 
    "Name", 
    "Role", 
    "PasswordHash", 
    "HasPassword",
    "CreatedAt"
)
VALUES (
    'admin@sparkpens.com',  -- Email
    'Admin',                -- Name
    'Admin',                -- Role (pastikan uppercase)
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQ3Z9x9Wq',  -- BCrypt hash for "admin"
    TRUE,                   -- HasPassword
    NOW()                   -- CreatedAt
)
ON CONFLICT DO NOTHING;
*/

-- =============================================================================
-- Cara 2: Update password user yang sudah ada
-- =============================================================================

-- Untuk mereset password admin yang sudah ada:
/*
UPDATE "Users"
SET "PasswordHash" = '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQ3Z9x9Wq',
    "HasPassword" = TRUE
WHERE "Role" = 'Admin';
*/

-- =============================================================================
-- Cara 3: Jika ingin membuat user biasa (mahasiswa/dosen)
-- =============================================================================

-- Contoh membuat user biasa:
/*
INSERT INTO "Users" (
    "Email", 
    "Name", 
    "Role", 
    "PasswordHash",
    "HasPassword",
    "CreatedAt"
)
VALUES (
    'dosen@pens.ac.id',                    -- Email
    'Budi Santoso',                        -- Name  
    'User',                                -- Role
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQ3Z9x9Wq',  -- Hash password
    TRUE,
    NOW()
);
*/

-- =============================================================================
-- Cara 4: Menghapus semua data dan memulai fresh
-- =============================================================================

-- ⚠️ PERINGATAN: Ini akan menghapus SEMUA data!
-- =============================================================================
/*
-- Hapus semua bookings
DELETE FROM "Bookings";

-- Hapus semua rooms
DELETE FROM "Rooms";

-- Hapus semua users (kecuali jika ada constraint)
DELETE FROM "Users";

-- Reset sequence IDs
ALTER SEQUENCE "Users_Id_seq" RESTART WITH 1;
ALTER SEQUENCE "Rooms_Id_seq" RESTART WITH 1;
ALTER SEQUENCE "Bookings_Id_seq" RESTART WITH 1;

-- Insert admin user
INSERT INTO "Users" (
    "Email", 
    "Name", 
    "Role", 
    "PasswordHash", 
    "HasPassword",
    "CreatedAt"
)
VALUES (
    'admin@sparkpens.com',
    'Admin',
    'Admin',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQ3Z9x9Wq',
    TRUE,
    NOW()
);
*/

-- =============================================================================
-- Verifikasi / Verification
-- =============================================================================

-- Cek semua user:
SELECT 
    "Id",
    "Email",
    "Name",
    "Role",
    "HasPassword",
    "GoogleId" IS NOT NULL AS "HasGoogleId",
    "CreatedAt"
FROM "Users"
ORDER BY "CreatedAt" DESC;

-- Cek apakah admin sudah dibuat:
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'Admin user EXISTS'
        ELSE 'Admin user NOT FOUND'
    END AS "AdminStatus"
FROM "Users"
WHERE "Role" = 'Admin';

-- =============================================================================
-- Default Credentials (Setelah SQL dijalankan)
-- =============================================================================
--
-- Username/Email: admin
-- Password: admin
--
-- =============================================================================

-- =============================================================================
-- Informasi Tambahan:
-- =============================================================================
--
-- Password Hash Algorithm: BCrypt
-- Cost Factor: 12
-- Default Password: admin
--
-- BCrypt Hash untuk "admin":
-- $2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYfQ3Z9x9Wq
--
-- Jika Anda ingin generate hash baru untuk password lain:
-- Anda bisa menggunakan online BCrypt generator atau library BCrypt
--
-- Contoh BCrypt di command line:
-- python3 -c "import bcrypt; print(bcrypt.hashpw(b'password', bcrypt.gensalt(12)).decode())"
--
-- =============================================================================

