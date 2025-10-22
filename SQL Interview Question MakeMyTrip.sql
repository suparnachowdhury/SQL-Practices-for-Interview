-- SQL Interview Questions MakeMYTrip Q2

-- Write an SQL query to find, for each segment, the user who made the earliest booking in April 2022
-- and also return how many total bookings that user made in April 2022
-- Your final result set must include segment, user_id, first_booking_date_April2022, total_bookings_April2022


create table booking_table (
    booking_id varchar(10),
    booking_date date,
    user_id varchar(10),
    line_of_business varchar(20)
);

insert into booking_table (booking_id, booking_date, user_id, line_of_business) values
('b1',  '2022-03-23', 'u1', 'Flight'),
('b2',  '2022-03-27', 'u2', 'Flight'),
('b3',  '2022-03-28', 'u1', 'Hotel'),
('b4',  '2022-03-31', 'u4', 'Flight'),
('b5',  '2022-04-02', 'u1', 'Hotel'),
('b6',  '2022-04-02', 'u2', 'Flight'),
('b7',  '2022-04-06', 'u5', 'Flight'),
('b8',  '2022-04-06', 'u6', 'Hotel'),
('b9',  '2022-04-06', 'u2', 'Flight'),
('b10', '2022-04-10', 'u1', 'Flight'),
('b11', '2022-04-12', 'u4', 'Flight'),
('b12', '2022-04-16', 'u1', 'Flight'),
('b13', '2022-04-19', 'u2', 'Flight'),
('b14', '2022-04-20', 'u5', 'Hotel'),
('b15', '2022-04-22', 'u6', 'Flight'),
('b16', '2022-04-26', 'u4', 'Hotel'),
('b17', '2022-04-28', 'u2', 'Hotel'),
('b18', '2022-04-30', 'u1', 'Hotel'),
('b19', '2022-05-04', 'u4', 'Hotel'),
('b20', '2022-05-06', 'u1', 'Flight');

create table user_table (
    user_id varchar(10),
    segment varchar(10)
);

insert into user_table (user_id, segment) values
('u1', 's1'),
('u2', 's1'),
('u3', 's1'),
('u4', 's2'),
('u5', 's2'),
('u6', 's3'),
('u7', 's3'),
('u8', 's3'),
('u9', 's3'),
('u10', 's3');

WITH booking_Apr2022 AS(
SELECT
	b.*
    , u.segment
    , ROW_NUMBER() OVER(PARTITION BY u.segment ORDER BY b.booking_date ASC) AS rn
    , COUNT(b.user_id) OVER(PARTITION BY u.segment, b.user_id) AS total_bookings_Apr2022
FROM booking_table b
JOIN user_table u
ON b.user_id = u.user_id
WHERE b.booking_date BETWEEN '2022-04-01' AND '2022-04-30')
SELECT
	segment
    ,user_id
    , booking_date AS first_booking_date_Apr2022
    , TOTAL_BOOKINGS_Apr2022
FROM booking_Apr2022
WHERE rn = 1;

-- drop table booking_table, user_table;