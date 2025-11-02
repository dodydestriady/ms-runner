-- File ini akan dijalankan sekali saat container postgres pertama kali dibuat
CREATE DATABASE productdb;
CREATE DATABASE orderdb;
-- Berikan hak akses ke user 'postgres' (opsional, tapi baik untuk kejelasan)
GRANT ALL PRIVILEGES ON DATABASE productdb TO postgres;
GRANT ALL PRIVILEGES ON DATABASE orderdb TO postgres;