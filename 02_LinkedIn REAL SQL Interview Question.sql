-- Create the table
CREATE TABLE emp_details (
    emp_name VARCHAR(10),
    city VARCHAR(15)
);

-- Insert sample data
INSERT INTO emp_details (emp_name, city) VALUES
('Sam', 'New York'),
('David', 'New York'),
('Peter', 'New York'),
('Chris', 'New York'),
('John', 'New York'),
('Steve', 'San Francisco'),
('Rachel', 'San Francisco'),
('Robert', 'Los Angeles');

select * from emp_details;

select city,
STRING_AGG(emp_name, ' ,') as team_group
from emp_details
group by city;

	WITH city_groups AS (
	SELECT
		  *,
		  CEILING(ROW_NUMBER() OVER(PARTITION BY city ORDER BY city)/3.0) AS team_no
	FROM emp_details)
	SELECT TOP 20 city,
	CONCAT('Team', ROW_NUMBER() OVER(ORDER BY city)) AS team_name,
	STRING_AGG(emp_name, ' ,') AS team_members
	FROM city_groups
	GROUP BY city, team_no;

