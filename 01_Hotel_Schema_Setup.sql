-- =========================================
-- HOTEL MANAGEMENT SYSTEM - SCHEMA SETUP
-- =========================================

DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address VARCHAR(255)
);

CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

INSERT INTO users VALUES
('u1', 'John Doe', '9876543210', 'john@example.com', 'ABC Street'),
('u2', 'Alice', '9876543211', 'alice@example.com', 'XYZ Street'),
('u3', 'Bob', '9876543212', 'bob@example.com', 'LMN Street');

INSERT INTO bookings VALUES
('b1', '2021-09-23 07:36:48', 'rm101', 'u1'),
('b2', '2021-10-10 10:00:00', 'rm102', 'u1'),
('b3', '2021-11-15 09:30:00', 'rm103', 'u2'),
('b4', '2021-11-20 12:45:00', 'rm104', 'u3'),
('b5', '2021-12-05 08:20:00', 'rm105', 'u2');

INSERT INTO items VALUES
('i1', 'Tawa Paratha', 18),
('i2', 'Mix Veg', 89),
('i3', 'Paneer Curry', 150),
('i4', 'Rice', 60),
('i5', 'Soup', 120);

INSERT INTO booking_commercials VALUES
('bc1', 'b1', 'bill1', '2021-09-23 12:03:22', 'i1', 3),
('bc2', 'b1', 'bill1', '2021-09-23 12:03:22', 'i2', 1),
('bc3', 'b2', 'bill2', '2021-10-10 14:20:00', 'i3', 5),
('bc4', 'b2', 'bill2', '2021-10-10 14:20:00', 'i4', 4),
('bc5', 'b3', 'bill3', '2021-11-15 13:00:00', 'i2', 2),
('bc6', 'b3', 'bill3', '2021-11-15 13:00:00', 'i5', 3),
('bc7', 'b4', 'bill4', '2021-11-20 15:00:00', 'i3', 1),
('bc8', 'b4', 'bill4', '2021-11-20 15:00:00', 'i4', 2),
('bc9', 'b5', 'bill5', '2021-12-05 11:10:00', 'i1', 10);