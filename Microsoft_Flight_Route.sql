CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time datetime,
    end_time datetime
);

INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');


INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');

select * from flights;
SELECT * FROM airports;

	WITH flight_details AS (
	SELECT f.flight_id, s.city_name start_city, e.city_name end_city,f.start_time,f.end_time
	FROM flights f
	JOIN airports s ON f.start_port = s.port_code
	JOIN airports e ON f.end_port= e.port_code),
	direct as ( 
		SELECT start_city, null as middle_city,end_city,flight_id
		, DATEDIFF(MINUTE, start_time, end_time) time_taken
	FROM flight_details 
	WHERE start_city = 'New York' AND end_city = 'Tokyo'
	)
	SELECT a1.start_city, a1.end_city middle_city,a2.end_city
	,  CAST(a1.flight_id AS VARCHAR) + ', ' + CAST(a2.flight_id AS VARCHAR) AS flight_id
	, DATEDIFF(MINUTE, a1.start_time, a2.end_time) time_taken
	FROM 
	( SELECT * FROM flight_details WHERE start_city = 'New York' ) a1
	JOIN 
	( SELECT * FROM flight_details WHERE end_city = 'Tokyo') a2
	ON (a1.end_city = a2.start_city) AND a1.end_time <= a2.start_time
	UNION ALL
	SELECT * FROM direct;
