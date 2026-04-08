-- ============================================================
-- PlatinumRx Assignment | Clinic Management System
-- File: 03_Clinic_Schema_Setup.sql
-- Purpose: Table creation + sample data insertion
-- ============================================================

DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- ------------------------------------------------------------
-- Table: clinics
-- ------------------------------------------------------------
CREATE TABLE clinics (
    cid         VARCHAR(50)  PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

-- ------------------------------------------------------------
-- Table: customer
-- ------------------------------------------------------------
CREATE TABLE customer (
    uid    VARCHAR(50)  PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    mobile VARCHAR(20)
);

-- ------------------------------------------------------------
-- Table: clinic_sales
-- ------------------------------------------------------------
CREATE TABLE clinic_sales (
    oid          VARCHAR(50)    PRIMARY KEY,
    uid          VARCHAR(50)    NOT NULL,
    cid          VARCHAR(50)    NOT NULL,
    amount       DECIMAL(12, 2) NOT NULL,
    datetime     DATETIME       NOT NULL,
    sales_channel VARCHAR(50)   NOT NULL,
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ------------------------------------------------------------
-- Table: expenses
-- ------------------------------------------------------------
CREATE TABLE expenses (
    eid         VARCHAR(50)    PRIMARY KEY,
    cid         VARCHAR(50)    NOT NULL,
    description VARCHAR(255),
    amount      DECIMAL(12, 2) NOT NULL,
    datetime    DATETIME       NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
-- Sample Data
-- ============================================================

INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001', 'XYZ Clinic',    'Hyderabad', 'Telangana',    'India'),
('cnc-0100002', 'ABC Health',    'Hyderabad', 'Telangana',    'India'),
('cnc-0100003', 'MedCare Plus',  'Pune',      'Maharashtra',  'India'),
('cnc-0100004', 'LifeWell',      'Pune',      'Maharashtra',  'India'),
('cnc-0100005', 'City Clinic',   'Chennai',   'Tamil Nadu',   'India'),
('cnc-0100006', 'Apollo Mini',   'Chennai',   'Tamil Nadu',   'India');

INSERT INTO customer (uid, name, mobile) VALUES
('cu-001', 'Jon Doe',     '9700000001'),
('cu-002', 'Mary Jane',   '9700000002'),
('cu-003', 'Peter Parker','9700000003'),
('cu-004', 'Bruce Wayne', '9700000004'),
('cu-005', 'Clark Kent',  '9700000005');

-- clinic_sales – mix of channels: online, offline, sodat, app
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
('ord-001', 'cu-001', 'cnc-0100001', 24999, '2021-01-10 10:00:00', 'online'),
('ord-002', 'cu-002', 'cnc-0100001', 15000, '2021-01-15 11:00:00', 'offline'),
('ord-003', 'cu-003', 'cnc-0100002', 8000,  '2021-02-05 09:30:00', 'app'),
('ord-004', 'cu-001', 'cnc-0100002', 12000, '2021-02-20 14:00:00', 'sodat'),
('ord-005', 'cu-004', 'cnc-0100003', 30000, '2021-03-08 08:00:00', 'online'),
('ord-006', 'cu-005', 'cnc-0100003', 5000,  '2021-03-22 17:00:00', 'offline'),
('ord-007', 'cu-002', 'cnc-0100004', 22000, '2021-04-11 12:00:00', 'app'),
('ord-008', 'cu-003', 'cnc-0100004', 9000,  '2021-05-01 10:30:00', 'sodat'),
('ord-009', 'cu-001', 'cnc-0100005', 18000, '2021-06-14 15:00:00', 'online'),
('ord-010', 'cu-004', 'cnc-0100005', 27000, '2021-07-19 13:00:00', 'offline'),
('ord-011', 'cu-005', 'cnc-0100006', 11000, '2021-08-03 09:00:00', 'app'),
('ord-012', 'cu-002', 'cnc-0100006', 33000, '2021-09-25 16:00:00', 'sodat'),
('ord-013', 'cu-001', 'cnc-0100001', 19500, '2021-10-07 11:30:00', 'online'),
('ord-014', 'cu-003', 'cnc-0100002', 7000,  '2021-11-12 14:30:00', 'offline'),
('ord-015', 'cu-004', 'cnc-0100003', 41000, '2021-12-28 10:00:00', 'app'),
('ord-016', 'cu-005', 'cnc-0100001', 6500,  '2021-11-20 12:00:00', 'sodat'),
('ord-017', 'cu-002', 'cnc-0100002', 14000, '2021-12-05 08:30:00', 'online');

-- expenses
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-001', 'cnc-0100001', 'first-aid supplies',  557,   '2021-01-05 07:36:48'),
('exp-002', 'cnc-0100001', 'electricity bill',    3200,  '2021-02-01 09:00:00'),
('exp-003', 'cnc-0100002', 'rent',                8000,  '2021-02-01 09:00:00'),
('exp-004', 'cnc-0100002', 'medicines stock',     4500,  '2021-03-10 10:00:00'),
('exp-005', 'cnc-0100003', 'staff salary',        25000, '2021-03-31 18:00:00'),
('exp-006', 'cnc-0100003', 'cleaning supplies',   1200,  '2021-04-15 11:00:00'),
('exp-007', 'cnc-0100004', 'rent',                12000, '2021-05-01 09:00:00'),
('exp-008', 'cnc-0100004', 'equipment repair',    3000,  '2021-06-20 14:00:00'),
('exp-009', 'cnc-0100005', 'staff salary',        30000, '2021-07-31 18:00:00'),
('exp-010', 'cnc-0100005', 'medicines stock',     6000,  '2021-08-12 10:00:00'),
('exp-011', 'cnc-0100006', 'electricity bill',    2800,  '2021-09-05 09:00:00'),
('exp-012', 'cnc-0100006', 'cleaning supplies',   900,   '2021-10-18 11:00:00'),
('exp-013', 'cnc-0100001', 'staff salary',        20000, '2021-11-30 18:00:00'),
('exp-014', 'cnc-0100002', 'rent',                8000,  '2021-12-01 09:00:00'),
('exp-015', 'cnc-0100003', 'medicines stock',     5500,  '2021-12-10 10:00:00');
