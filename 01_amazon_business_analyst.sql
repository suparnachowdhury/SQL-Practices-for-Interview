/*
𝗔𝗺𝗮𝘇𝗼𝗻 𝗕𝘂𝘀𝗶𝗻𝗲𝘀𝘀 𝗔𝗻𝗮𝗹𝘆𝘀𝘁 𝗜𝗻𝘁𝗲𝗿𝘃𝗶𝗲𝘄 𝗤𝘂𝗲𝘀𝘁𝗶𝗼𝗻𝘀:
𝗣𝗿𝗼𝗯𝗹𝗲𝗺 𝗦𝘁𝗮𝘁𝗲𝗺𝗲𝗻𝘁: 
Given a subscribers table that tracks each customer's plan changes over time, identify all customers and classify
whether they have ever upgraded (moved to a higher-value plan) or downgraded (moved to a lower-value plan) at least once. 
Display the result as Yes or No for each category per customer.


*/

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

-- Solution:

	WITH plan_changes AS (
		SELECT customer_id,
			   plan_value,
			   LAG(plan_value) OVER (PARTITION BY customer_id ORDER BY subscription_date) AS prev_plan_value
		FROM subscribers
	),
	customer_flags AS (
		SELECT customer_id,
			   MAX(CASE WHEN plan_value > prev_plan_value THEN 1 ELSE 0 END) AS has_upgraded,
			   MAX(CASE WHEN plan_value < prev_plan_value THEN 1 ELSE 0 END) AS has_downgraded
		FROM plan_changes
		WHERE prev_plan_value IS NOT NULL
		GROUP BY customer_id
	)
	SELECT customer_id,
		   CASE WHEN has_upgraded  = 1 THEN 'Yes' ELSE 'No' END AS upgraded,
		   CASE WHEN has_downgraded = 1 THEN 'Yes' ELSE 'No' END AS downgraded
	FROM customer_flags
	ORDER BY customer_id;