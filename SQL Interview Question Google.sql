-- You are given a transaction table, which records transactions between sellers and buyers. 
-- The structure of the table is as follows:Transaction_ID (INT), Customer_ID (INT), Amount (INT), Date (timestamp)

-- Every successful transaction will have two row entries into the table with two different 
-- transaction_id but in ascending order sequence, the first one for the seller where their
-- customer_id will be registered, and the second one for the buyer where their customer_id
-- will be registered. The amount and date_time for both will however be the same.

-- Write an SQL query to find the top 5 seller-buyer combinations with the highest number of
-- transactions between them.
-- Disqualify all sellers who have acted as buyers and all buyers who have acted as sellers.


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date datetime
);

-- delete from Transactions;
INSERT INTO Transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO Transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');


SELECT * FROM transactions;

with paired_transactions as (
    select * from (
        select 
            transaction_id,
            customer_id as seller,
            amount,
            lead(customer_id) over (order by transaction_id) as buyer
        from transactions
    ) t
    where transaction_id % 2 = 1
), mutual_parties as (
    select seller
    from paired_transactions
    intersect
    select buyer
    from paired_transactions
)
select 
    seller,
    buyer,
    count(*) as no_transaction
from paired_transactions
where seller not in (select seller from mutual_parties)
group by seller, buyer
order by no_transaction desc;
