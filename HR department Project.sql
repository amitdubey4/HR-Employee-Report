CREATE DATABASE project1;

USE project1;

SELECT * FROM hr;

#Renaming the columns
ALTER TABLE hr 
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT * FROM hr;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT hire_date FROM hr;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

SELECT termdate FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- Step 1: Update the empty rows with '0000-00-00'
UPDATE hr
SET termdate = date('0000-00-00') 
WHERE termdate is NULL;

SELECT termdate FROM hr;
SET sql_mode = '';
-- Step 2: Alter the column to change its datatype to DATE
ALTER TABLE hr
MODIFY termdate DATE;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr 
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

SELECT 
	MIN(age) as youngest,
    MAX(age) as oldest
FROM hr;

SELECT COUNT(*) FROM hr
WHERE age <18;

#Moving forward we will only consider employee who's age is greater then equal to 18
SELECT * FROM hr;
-- 1
SELECT gender, COUNT(*) as count FROM hr
WHERE age >18 and termdate = '0000-00-00'
GROUP BY gender;

-- 2
SELECT race, COUNT(*) as count FROM hr
WHERE age >18 and termdate = '0000-00-00'
GROUP BY race;
 
-- 3
SELECT 
	MIN(age) as youngest,
    MAX(age) as oldest
FROM hr
WHERE age >=18 and termdate = '0000-00-00';

SELECT 
	CASE 
		WHEN age between 18 and 30 then '18-30'
        WHEN age between 31 and 40 then '31-45'
        WHEN age between 41 and 50 then '41-50'
        ELSE '50+'
	END AS age_group, gender,
    count(*) as count
FROM hr
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4
SELECT location, COUNT(*) as count FROM hr
WHERE age >18 and termdate = '0000-00-00'
GROUP BY location;

-- 5
SELECT round(avg(timestampdiff(year, hire_date, termdate)),0) as year from hr
WHERE termdate <= curdate() and termdate <> '0000-00-00' and age >=18;

-- 6

SELECT department, gender, jobtitle, count(*) as count FROM hr
WHERE age >18 and termdate = '0000-00-00'
GROUP BY department, gender, jobtitle
order by department;

-- 7
SELECT jobtitle, count(*) as count FROM hr
WHERE age >18 and termdate = '0000-00-00'
GROUP BY jobtitle
order by count desc; 

-- 8 
select * from hr;

-- 9 
SELECT location_city, location_state, count(*) as count FROM hr 
WHERE age >18 and termdate = '0000-00-00'
GROUP BY location_city, location_state
ORDER BY count DESC;

 -- 10
 SELECT 
	YEAR,
    hires,
    terminations,
    hires - terminations as net_change,
    round((hires - terminations)/hires * 100, 2) as net_percent
	FROM (
		SELECT YEAR(hire_date) AS YEAR, 
        count(*) AS hires, 
        SUM(CASE WHEN termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
        from hr
        where age >=18
        group by year(hire_date)
    )as subquery
 order by year asc;

 -- 11
 SELECT department, round(avg(timestampdiff(YEAR, hire_date, termdate)),0) as avg_tenure
 FROM hr
 WHERE age >=18 and termdate <> '0000-00-00' and termdate <= curdate()
 group by department;
 

 
 
 
 
 
 
 
