DROP TABLE IF EXISTS Transactions CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DELETE FROM transactions;

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    avatar TEXT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE Transactions (
    id SERIAL PRIMARY KEY,
    amount DECIMAL(15,2) NOT NULL,
	transaction_type VARCHAR(20) NOT NULL, 
    date_time TIMESTAMPTZ NOT NULL,
    transaction_no VARCHAR(50) UNIQUE NOT NULL,
    sender_id INT REFERENCES Users(id),
    receiver_id INT REFERENCES Users(id),
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'failed')) NOT NULL
);

INSERT INTO Users (name, username, email, password, phone_number) VALUES
('Mute', 'Mutekeren', 'mute12@example.com', 'admin', '081234567890'),
('Adios', 'adiosdios', 'adioswakwaw@example.com', 'admin', '081234567891'),
('Helmi', 'aku_ganteng', 'helmiganteng@example.com', 'admin', '081234567892'),
('Khansa', 'KhansaCute', 'khansacute@example.com', 'admin', '081234567893'),
('Mail', 'fadhil_ganteng', 'purwakartajaya@example.com', 'admin', '082234567892'),
('ViraIT', 'Vira_IT', 'virabsi@example.com', 'admin', '089934567893');

INSERT INTO Transactions (amount,transaction_type, date_time, transaction_no, sender_id, receiver_id, status) VALUES
(-75000.00,'transfer', '2022-06-30 20:10:00', 'TXN001', 1, NULL, 'completed'), -- Transfer dari Mute
(1000000.00,'top_up', '2022-06-30 20:10:00', 'TXN002', NULL, 1, 'completed'), -- Top-up ke Mute
(-75000.00,'transfer', '2022-06-30 20:10:00', 'TXN003', 2, NULL, 'completed'), -- Transfer dari Adios
(1000000.00,'top_up', '2022-06-30 20:10:00', 'TXN004', NULL, 2, 'completed'), -- Top-up ke Adios
(-75000.00,'transfer', '2022-06-30 20:10:00', 'TXN005', 3, NULL, 'completed'), -- Transfer dari Helmi
(1000000.00,'top_up', '2022-06-30 20:10:00', 'TXN006', NULL, 3, 'completed'), -- Top-up ke Helmi
(-75000.00,'transfer', '2022-06-30 20:10:00', 'TXN007', 4, NULL, 'completed'), -- Transfer dari Khansa
(1000000.00,'tup_up', '2022-06-30 20:10:00', 'TXN008', NULL, 4, 'completed'); -- Top-up ke Khansa

TRUNCATE TABLE Transactions RESTART IDENTITY CASCADE;
SELECT * FROM Users;
SELECT * FROM Transactions;


SELECT t.date_time, t.transaction_type,
CASE 
    WHEN t.transaction_type = 'transfer' AND t.sender_id = 1 THEN r.name
    WHEN t.transaction_type = 'transfer' AND t.receiver_id = 1 THEN s.name
    WHEN t.transaction_type = 'top_up' AND (t.sender_id = 1 OR t.receiver_id = 1) THEN 'Top-up'
END AS fromto,
t.status,
CASE 
    WHEN t.sender_id = 1 THEN CONCAT ('-', t.amount)
    WHEN t.receiver_id = 1 THEN CONCAT ('+', t.amount)
END AS amount
FROM transactions t
LEFT JOIN users s ON t.sender_id = s.id
LEFT JOIN users r ON t.receiver_id = r.id
WHERE t.sender_id = 1 OR t.receiver_id = 1;



FROM (
	SELECT * FROM users INNER JOIN transaction ON users.id = transaction.sender_id WHERE transaction.sender_id = 1
	UNION
	SELECT * FROM users INNER JOIN transaction ON users.id = transaction.receiver_id WHERE transaction.receiver_id = 1
)


