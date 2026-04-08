-- ============================================================
-- PlatinumRx Assignment | Hotel Management System
-- File: 01_Hotel_Schema_Setup.sql
-- Purpose: Table creation + sample data insertion
-- ============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- ------------------------------------------------------------
-- Table: users
-- ------------------------------------------------------------
CREATE TABLE users (
    user_id        VARCHAR(50)  PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    phone_number   VARCHAR(20),
    mail_id        VARCHAR(100),
    billing_address TEXT
);

-- ------------------------------------------------------------
-- Table: items
-- ------------------------------------------------------------
CREATE TABLE items (
    item_id   VARCHAR(50)    PRIMARY KEY,
    item_name VARCHAR(100)   NOT NULL,
    item_rate DECIMAL(10, 2) NOT NULL
);

-- ------------------------------------------------------------
-- Table: bookings
-- ------------------------------------------------------------
CREATE TABLE bookings (
    booking_id   VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME    NOT NULL,
    room_no      VARCHAR(50) NOT NULL,
    user_id      VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ------------------------------------------------------------
-- Table: booking_commercials
-- ------------------------------------------------------------
CREATE TABLE booking_commercials (
    id            VARCHAR(50)    PRIMARY KEY,
    booking_id    VARCHAR(50)    NOT NULL,
    bill_id       VARCHAR(50)    NOT NULL,
    bill_date     DATETIME       NOT NULL,
    item_id       VARCHAR(50)    NOT NULL,
    item_quantity DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
-- Sample Data
-- ============================================================

INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('21wrcxuy-67erfn', 'John Doe',   '9700000001', 'john.doe@example.com',   '10, Street A, Delhi'),
('u2-abcdef-12345', 'Jane Smith', '9700000002', 'jane.smith@example.com', '20, Street B, Mumbai'),
('u3-ghijkl-67890', 'Bob Ray',    '9700000003', 'bob.ray@example.com',    '30, Street C, Pune'),
('u4-mnopqr-11223', 'Alice Brown','9700000004', 'alice@example.com',      '40, Street D, Hyderabad');

INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-a9e8-q8fu',  'Tawa Paratha', 18.00),
('itm-a07vh-aer8', 'Mix Veg',      89.00),
('itm-w978-23u4',  'Butter Naan',  35.00),
('itm-b123-c456',  'Paneer Tikka', 150.00),
('itm-d789-e012',  'Dal Makhani',  120.00),
('itm-f345-g678',  'Biryani',      200.00),
('itm-h901-i234',  'Cold Drink',   60.00);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-q034-q4o',   '2021-10-05 09:00:00', 'rm-c001-xyz',   'u2-abcdef-12345'),
('bk-r111-abc',   '2021-10-18 14:20:00', 'rm-bhf9-aerjn', 'u3-ghijkl-67890'),
('bk-s222-def',   '2021-11-03 11:00:00', 'rm-d002-lmn',   '21wrcxuy-67erfn'),
('bk-t333-ghi',   '2021-11-15 10:30:00', 'rm-e003-opq',   'u2-abcdef-12345'),
('bk-u444-jkl',   '2021-11-28 16:45:00', 'rm-f004-rst',   'u4-mnopqr-11223'),
('bk-v555-mno',   '2021-12-01 08:00:00', 'rm-g005-uvw',   'u3-ghijkl-67890'),
('bk-w666-pqr',   '2021-12-20 12:00:00', 'rm-h006-xyz',   'u4-mnopqr-11223');

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
-- September bookings
('bc-001', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu',  3),
('bc-002', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('bc-003', 'bk-q034-q4o',   'bl-34qhd-r7h8', '2021-10-05 18:05:37', 'itm-w978-23u4',  4),
('bc-004', 'bk-q034-q4o',   'bl-34qhd-r7h8', '2021-10-05 18:05:37', 'itm-b123-c456',  5),
('bc-005', 'bk-q034-q4o',   'bl-34qhd-r7h8', '2021-10-05 18:05:37', 'itm-d789-e012',  3),
('bc-006', 'bk-r111-abc',   'bl-r111-b001',   '2021-10-18 20:00:00', 'itm-f345-g678',  2),
('bc-007', 'bk-r111-abc',   'bl-r111-b001',   '2021-10-18 20:00:00', 'itm-h901-i234',  5),
('bc-008', 'bk-r111-abc',   'bl-r111-b001',   '2021-10-18 20:00:00', 'itm-a9e8-q8fu',  6),
-- November bookings
('bc-009', 'bk-s222-def',   'bl-s222-b001',   '2021-11-03 13:00:00', 'itm-b123-c456',  4),
('bc-010', 'bk-s222-def',   'bl-s222-b001',   '2021-11-03 13:00:00', 'itm-d789-e012',  2),
('bc-011', 'bk-t333-ghi',   'bl-t333-b001',   '2021-11-15 19:00:00', 'itm-f345-g678',  3),
('bc-012', 'bk-t333-ghi',   'bl-t333-b001',   '2021-11-15 19:00:00', 'itm-w978-23u4',  8),
('bc-013', 'bk-u444-jkl',   'bl-u444-b001',   '2021-11-28 21:00:00', 'itm-a07vh-aer8', 6),
('bc-014', 'bk-u444-jkl',   'bl-u444-b001',   '2021-11-28 21:00:00', 'itm-h901-i234',  10),
-- December bookings
('bc-015', 'bk-v555-mno',   'bl-v555-b001',   '2021-12-01 12:00:00', 'itm-b123-c456',  3),
('bc-016', 'bk-v555-mno',   'bl-v555-b001',   '2021-12-01 12:00:00', 'itm-f345-g678',  2),
('bc-017', 'bk-w666-pqr',   'bl-w666-b001',   '2021-12-20 14:00:00', 'itm-d789-e012',  7),
('bc-018', 'bk-w666-pqr',   'bl-w666-b001',   '2021-12-20 14:00:00', 'itm-a9e8-q8fu',  12);
