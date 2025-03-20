DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    user_type VARCHAR(20) NOT NULL, 
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    avatar TEXT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE Transaction (
    id SERIAL PRIMARY KEY,
    amount DECIMAL(15,2) NOT NULL,
    date_time TIMESTAMPTZ NOT NULL,
    transaction_no VARCHAR(50) UNIQUE NOT NULL,
    sender_id INT REFERENCES Users(id),
    receiver_id INT REFERENCES Users(id),
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'failed')) NOT NULL
);

INSERT INTO Users (name, user_type, username, email, password, phone_number) VALUES
('Mute', 'transfer', 'Mutekeren', 'mute12@example.com', 'admin', '081234567890'),
('Adios', 'top_up', 'adiosdios', 'adioswakwaw@example.com', 'admin', '081234567891'),
('Helmi', 'transfer', 'aku_ganteng', 'helmiganteng@example.com', 'admin', '081234567892'),
('Khansa', 'top_up', 'KhansaCute', 'khansacute@example.com', 'admin', '081234567893'),
('Mail', 'transfer', 'fadhil_ganteng', 'purwakartajaya@example.com', 'admin', '082234567892'),
('ViraIT', 'top_up', 'Vira_IT', 'virabsi@example.com', 'admin', '089934567893');

INSERT INTO Transaction (amount, date_time, transaction_no, sender_id, receiver_id, status) VALUES
(-75000.00, '2022-06-30 20:10:00', 'TXN001', 1, NULL, 'completed'), -- Transfer dari Mute
(1000000.00, '2022-06-30 20:10:00', 'TXN002', NULL, 1, 'completed'), -- Top-up ke Mute
(-75000.00, '2022-06-30 20:10:00', 'TXN003', 2, NULL, 'completed'), -- Transfer dari Adios
(1000000.00, '2022-06-30 20:10:00', 'TXN004', NULL, 2, 'completed'), -- Top-up ke Adios
(-75000.00, '2022-06-30 20:10:00', 'TXN005', 3, NULL, 'completed'), -- Transfer dari Helmi
(1000000.00, '2022-06-30 20:10:00', 'TXN006', NULL, 3, 'completed'), -- Top-up ke Helmi
(-75000.00, '2022-06-30 20:10:00', 'TXN007', 4, NULL, 'completed'), -- Transfer dari Khansa
(1000000.00,'2022-06-30 20:10:00', 'TXN008', NULL, 4, 'completed'); -- Top-up ke Khansa

SELECT * FROM Users;
SELECT * FROM Transaction;
SELECT users.user_type FROM users;

SELECT transaction.date_time, users.user_type,
case when Users.user_type = 'transfer' AND transaction.sender_id = 1 then Users.name
when Users.user_type = 'transfer' AND transaction.receiver_id = 1 then (SELECT Users.name FROM users where id = transaction.sender_id)
when Users.user_type = 'top_up' AND transaction.sender_id = 1 OR transaction.receiver_id = 1 THEN ''
end as fromto,
transaction.status,
case when transaction.sender_id = 1 then CONCAT ('-', transaction.amount)
when transaction.receiver_id = 1 then CONCAT ('+', transaction.amount)
end as amount
from users
inner join transaction on Users.id = transaction.receiver_id 
where transaction.sender_id = 1 OR transaction.receiver_id = 1;


FROM (
	SELECT * FROM users INNER JOIN transaction ON users.id = transaction.sender_id WHERE transaction.sender_id = 1
	UNION
	SELECT * FROM users INNER JOIN transaction ON users.id = transaction.receiver_id WHERE transaction.receiver_id = 1
)


