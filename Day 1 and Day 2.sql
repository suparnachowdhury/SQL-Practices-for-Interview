-- Day 1: 
-- Difficulty: Easy

-- Problem: Inactive Users Percentage
-- Write a query to find the percentage of users who never performed a 'like' or 'comment',
-- rounded to two decimal places.

DROP TABLE IF EXISTS users, events;
CREATE TABLE users (
user_id INT PRIMARY KEY,
name VARCHAR(50)
);

INSERT INTO users (user_id, name) VALUES
(1, 'John'),
(2, 'Jane'),
(3, 'Bob'),
(4, 'Alice'),
(5, 'Mike'),
(6, 'Mona');

CREATE TABLE events (
event_id INT PRIMARY KEY,
user_id INT,
action VARCHAR(10),
created_at DATETIME,
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO events (event_id, user_id, action, created_at) VALUES
(1, 1, 'post', '2024-01-01 10:00:00'),
(2, 1, 'post', '2024-01-01 14:00:00'),
(3, 1, 'post', '2024-01-02 09:00:00'),
(4, 2, 'like', '2024-01-01 10:05:00'),
(5, 2, 'comment', '2024-01-01 10:10:00'),
(6, 2, 'post', '2024-01-01 15:00:00'),
(7, 2, 'like', '2024-01-02 10:00:00'),
(8, 2, 'comment', '2024-01-02 10:30:00'),
(9, 3, 'post', '2024-01-01 11:00:00'),
(10, 3, 'post', '2024-01-02 13:00:00'),
(11, 3, 'post', '2024-01-03 09:00:00'),
(12, 4, 'post', '2024-01-02 09:00:00'),
(13, 4, 'post', '2024-01-02 16:00:00'),
(14, 4, 'post', '2024-01-03 11:00:00'),
(15, 5, 'like', '2024-01-02 14:00:00'),
(16, 5, 'post', '2024-01-03 10:00:00'),
(17, 5, 'like', '2024-01-03 15:00:00');


SELECT * FROM users;
SELECT * FROM events;


SELECT 
    ROUND(100.0 * COUNT(u.user_id) / (SELECT COUNT(*) FROM users), 2) AS percentage
FROM users u
WHERE NOT EXISTS
(SELECT e.user_id FROM events e 
    WHERE u.user_id = e.user_id AND e.action IN ('like', 'comment'));



-- Day 2: 
-- Difficulty: Easy

-- Problem: Home Address Transaction Analysis
-- Write a query to calculate the percentage of each user's transactions that were shipped to 
-- their primary address, rounded to two decimal places and labeled as home_address_percent.

DROP TABLE IF EXISTS users, transactions;
CREATE TABLE users (
id INT PRIMARY KEY,
name VARCHAR(255),
address VARCHAR(255)
);

-- Users sample data
INSERT INTO users (id, name, address) VALUES
(1, 'John Doe', '123 Main St'),
(2, 'Jane Smith', '456 Elm St'),
(3, 'Alice Johnson', '789 Oak Ave');


CREATE TABLE transactions (
id INT PRIMARY KEY,
user_id INT,
created_at DATETIME,
shipping_address VARCHAR(255)
);

-- Transactions sample data
INSERT INTO transactions (id, user_id, created_at, shipping_address) VALUES
(1, 1, '2025-01-15 10:30:00', '123 Main St'), 
(2, 1, '2025-01-16 11:45:00', '789 Oak Ave'), 
(3, 2, '2025-01-17 14:20:00', '456 Elm St'), 
(4, 2, '2025-01-18 15:10:00', '123 Pine Rd'), 
(5, 3, '2025-01-19 16:05:00', '789 Oak Ave'), 
(6, 3, '2025-01-20 17:40:00', '123 Main St'),
(7, 3, '2025-01-21 17:45:00', '123 Main St');

SELECT * FROM transactions;
SELECT * FROM users;


	SELECT 
	   ROUND (
		 (COUNT(t.user_id) * 100.0) /
		 (SELECT COUNT(*) FROM transactions) 
	   , 2) home_address_percent
	FROM transactions t
	JOIN users u 
	ON t.user_id = u.id
	AND t.shipping_address = u.address
