-- List the top 3 users who accumulated the most sessions. 
-- Include only the user who had more streaming sessions than viewing. 
-- Return the user_id, number of streaming sessions, and number of viewing sessions.

CREATE TABLE twitch_session (
    user_id INT,
    session_start DATETIME,
    session_end DATETIME,
    session_id INT,
    session_type VARCHAR(20)
);
INSERT INTO twitch_session (user_id, session_start, session_end, session_id, session_type)
VALUES
(0, '2020-08-11 05:51:31', '2020-08-11 05:54:45', 539, 'streamer'),
(2, '2020-07-11 03:36:54', '2020-07-11 03:37:08', 840, 'streamer'),
(3, '2020-11-26 11:41:47', '2020-11-26 11:52:01', 848, 'streamer'),
(1, '2020-11-19 06:24:24', '2020-11-19 07:24:38', 515, 'viewer'),
(2, '2020-11-14 03:36:05', '2020-11-14 03:39:19', 646, 'viewer'),
(0, '2020-03-11 03:01:40', '2020-03-11 03:01:59', 782, 'streamer'),
(0, '2020-08-11 03:50:45', '2020-08-11 03:55:59', 815, 'viewer'),
(3, '2020-10-11 22:15:14', '2020-10-11 22:18:28', 630, 'viewer'),
(1, '2020-11-20 06:59:57', '2020-11-20 07:20:11', 907, 'streamer'),
(2, '2020-07-11 14:32:19', '2020-07-11 14:42:33', 949, 'viewer'),
(4, '2020-08-11 15:32:19', '2020-08-11 16:42:33', 818, 'viewer'),
(5, '2020-12-20 07:59:57', '2020-12-20 08:52:57', 619, 'streamer'),
(6, '2020-12-25 08:02:38', '0000-00-00 00:00:00', 832, 'streamer'),
(6, '2020-08-12 15:44:19', '2020-08-12 16:42:19', 762, 'streamer'),
(6, '2020-11-24 07:59:57', '0000-00-00 00:00:00', 760, 'streamer'),
(6, '2020-08-14 05:50:45', '0000-00-00 00:00:00', 544, 'viewer'),
(7, '2020-11-18 04:36:05', '2020-11-18 04:43:05', 906, 'streamer'),
(7, '2020-08-14 05:50:45', '2020-08-14 06:27:45', 645, 'streamer'),
(7, '2020-08-11 15:32:19', '2020-08-11 16:22:19', 817, 'viewer');

-- Solution

SELECT user_id
       , SUM(session_type = 'streamer') no_streaming
       , SUM(session_type= 'viewer') no_viewing
from twitch_sessions
GROUP BY user_id
HAVING SUM(session_type = 'streamer') > SUM(session_type= 'viewer')
ORDER BY no_streaming + no_viewing  DESC
LIMIT 3;