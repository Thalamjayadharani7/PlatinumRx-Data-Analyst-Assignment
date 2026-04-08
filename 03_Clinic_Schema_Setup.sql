-- =========================================
-- CLINIC MANAGEMENT SYSTEM - SCHEMA SETUP
-- =========================================

DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(255),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO clinics VALUES
('c1', 'XYZ Clinic', 'Hyderabad', 'Telangana', 'India'),
('c2', 'ABC Clinic', 'Hyderabad', 'Telangana', 'India'),
('c3', 'Health Plus', 'Vijayawada', 'Andhra Pradesh', 'India'),
('c4', 'Care Point', 'Guntur', 'Andhra Pradesh', 'India');

INSERT INTO customer VALUES
('cu1', 'Ravi', '9999991111'),
('cu2', 'Sita', '9999992222'),
('cu3', 'Arjun', '9999993333'),
('cu4', 'Meena', '9999994444');

INSERT INTO clinic_sales VALUES
('o1', 'cu1', 'c1', 2000, '2021-09-10 10:00:00', 'online'),
('o2', 'cu2', 'c1', 3000, '2021-09-15 11:00:00', 'offline'),
('o3', 'cu3', 'c2', 2500, '2021-09-18 12:00:00', 'online'),
('o4', 'cu1', 'c3', 5000, '2021-10-05 09:00:00', 'referral'),
('o5', 'cu4', 'c4', 1500, '2021-10-12 16:00:00', 'offline'),
('o6', 'cu2', 'c3', 3500, '2021-11-08 13:00:00', 'online'),
('o7', 'cu3', 'c4', 4500, '2021-11-20 15:30:00', 'referral');

INSERT INTO expenses VALUES
('e1', 'c1', 'supplies', 1000, '2021-09-11 08:00:00'),
('e2', 'c2', 'equipment', 1200, '2021-09-19 09:00:00'),
('e3', 'c3', 'staff salary', 2000, '2021-10-06 10:00:00'),
('e4', 'c4', 'maintenance', 800, '2021-10-13 11:00:00'),
('e5', 'c3', 'medicines', 1000, '2021-11-09 12:00:00'),
('e6', 'c4', 'utilities', 900, '2021-11-21 14:00:00');