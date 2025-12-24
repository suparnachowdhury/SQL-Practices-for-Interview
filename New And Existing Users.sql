-- Write a SQL query to calculate the monthly proportion of new versus existing users. 
-- A user is considered 'new' in the month of their first activity and 'existing' in 
-- all subsequent months. The output should show each month along with the percentage 
-- of new users and the percentage of existing users, ordered by month


CREATE TABLE user_events (
    id INT PRIMARY KEY,
    time_id DATETIME,
    user_id VARCHAR(50),
    event_type VARCHAR(50),
    event_id INT
);
INSERT INTO user_events (id, time_id, user_id, event_type, event_id)
VALUES
    (5, '2020-02-06 00:00:00', '9237-HQITU', 'video call received', 7),
    (1, '2020-02-28 00:00:00', '3668-QPYBK', 'message sent', 3),
    (2, '2020-02-28 00:00:00', '7892-POOKP', 'file received', 2),
    (6, '2020-02-27 00:00:00', '8191-XWSZG', 'file received', 2),
    (11, '2020-02-28 00:00:00', '5129-JLPIS', 'video call started', 6),
    (15, '2020-02-11 00:00:00', '9237-HQITU', 'video call received', 7),
    (8, '2020-03-01 00:00:00', '9763-GRSKD', 'message received', 4),
    (13, '2020-03-21 00:00:00', '6388-TABGU', 'message sent', 3),
    (14, '2020-03-03 00:00:00', '3668-QPYBK', 'video call received', 7),
    (12, '2020-03-31 00:00:00', '6713-OKOMC', 'file received', 2),
    (7, '2020-04-03 00:00:00', '9237-HQITU', 'video call received', 7),
    (3, '2020-04-03 00:00:00', '3668-QPYBK', 'video call received', 7),
    (4, '2020-04-02 00:00:00', '9763-GRSKD', 'video call received', 7),
    (9, '2020-04-02 00:00:00', '4190-MFLUW', 'video call received', 7);


WITH first_activity AS 
	(SELECT user_id, Month(Min(time_id)) first_month
         FROM   user_events
         GROUP  BY user_id), status AS 
	(SELECT DISTINCT ue.user_id, Month(ue.time_id) month,
			CASE WHEN fa.first_month = Month(ue.time_id) THEN 'new' 
                  ELSE 'existing' END  AS status
	 FROM user_events ue
     LEFT JOIN first_activity fa
     ON ue.user_id = fa.user_id)
SELECT month
      , Sum(CASE WHEN status = 'new' THEN 1 ELSE 0 END) * 1.0 / Count(*) AS new_perc
      , Sum(CASE WHEN status = 'existing' THEN 1 ELSE 0 END) * 1.0 / Count(*) 
                        AS existing_perc
FROM   status
GROUP  BY month
ORDER BY month; 

