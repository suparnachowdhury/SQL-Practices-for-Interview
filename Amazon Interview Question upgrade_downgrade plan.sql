-- Amazon Business Analyst Interview Questions

-- You have a table that tracks customer account changes. Write an SQL query to generate 
-- a report that lists every customer and indicates whether they have upgraded or downgraded 
-- their account at least once in their lifetime. Your final result set must include 
-- three columns: CustomerID, Upgraded, and Downgraded. The Upgraded and Downgraded columns 
-- should display a binary result, such as 'Yes' or 'No', to indicate the presence of at least 
-- one upgrade and/or at least one downgrade, respectively.

CREATE TABLE subscribers (
  customer_id INT,
  subscription_date DATE,
  plan_value INT
);

INSERT INTO subscribers VALUES
(1, '2023-03-02', 799),
(1, '2023-04-01', 599),
(1, '2023-05-01', 499),
(2, '2023-04-02', 799),
(2, '2023-07-01', 599),
(2, '2023-09-01', 499),
(3, '2023-01-01', 499),
(3, '2023-04-01', 599),
(3, '2023-07-02', 799),
(4, '2023-04-01', 499),
(4, '2023-09-01', 599),
(4, '2023-10-02', 499),
(4, '2023-11-02', 799),
(5, '2023-10-02', 799),
(5, '2023-11-02', 799),
(6, '2023-03-01', 499);


SELECT * FROM subscribers;

WITH prev_values AS (
SELECT
	*
    , LAG(plan_value, 1, plan_value) 
			OVER(PARTITION BY customer_id ORDER BY subscription_date) AS prev_value
FROM subscribers),
status AS (
	SELECT 
		customer_id
		, MAX(CASE WHEN plan_value > prev_value THEN 1 ELSE 0 END) AS upgraded
		, MAX(CASE WHEN plan_value < prev_value THEN 1 ELSE 0 END) AS downgraded
	FROM prev_values
	GROUP BY customer_id)
SELECT 
	customer_id
    , CASE WHEN upgraded = 1 THEN 'Yes' ELSE 'No' END AS upgraded
    , CASE WHEN downgraded = 1 THEN 'Yes' ELSE 'No' END AS downgraded
FROM status