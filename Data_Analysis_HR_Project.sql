-- Questions for Data Analysis

-- 1. What is the distribution of employees by gender in the company?
SELECT GENDER, COUNT(*) as COUNT
FROM hr_records
WHERE termdate IS NULL -- currently working in the company
GROUP BY GENDER;

-- 2. What is the distribution of employees by race/ethnicity in the company?
SELECT RACE, COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY RACE
ORDER  BY COUNT(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT CASE
WHEN AGE >= 18 AND AGE <= 24 THEN '18-24'
WHEN AGE >= 25 AND AGE <= 34 THEN '25-34'
WHEN AGE >= 35 AND AGE <= 44 THEN '35-44'
WHEN AGE >= 45 AND AGE <= 54 THEN '45-54'
WHEN AGE >= 55 AND AGE <= 64 THEN '55-64'
ELSE '65+'
END AS AGE_GROUP, COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY AGE_GROUP
ORDER BY AGE_GROUP
;

-- 4. What is the age distribution of employees by gender in the company?
SELECT CASE
WHEN AGE >= 18 AND AGE <= 24 THEN '18-24'
WHEN AGE >= 25 AND AGE <= 34 THEN '25-34'
WHEN AGE >= 35 AND AGE <= 44 THEN '35-44'
WHEN AGE >= 45 AND AGE <= 54 THEN '45-54'
WHEN AGE >= 55 AND AGE <= 64 THEN '55-64'
ELSE '65+'
END AS AGE_GROUP, GENDER, COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY AGE_GROUP, GENDER
ORDER BY AGE_GROUP, GENDER
;

-- 5. No. of employees that work at the headquarters vs remote locations?
SELECT location ,COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY location;

-- 6. What was the average tenure of employees who have been terminated?
SELECT ROUND(AVG(datediff(termdate, hire_date))/365,0) AS AVERAGE_TENURE -- for calculating years
FROM hr_records
WHERE termdate IS NOT NULL AND termdate <= curdate();

-- 7. How does the gender distribution vary across departments?
SELECT department, gender, COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY department, gender
ORDER BY department;

-- 8. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 9. Which department has the highest turnover rate?
SELECT department, TOTAL_COUNT, TERMINATION_COUNT, (TERMINATION_COUNT/TOTAL_COUNT) AS TERMINATION_RATE FROM
 (SELECT department, COUNT(*) AS TOTAL_COUNT,
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0
END) AS TERMINATION_COUNT
FROM hr_records
GROUP BY department)T
ORDER BY TERMINATION_RATE DESC
;

-- DEPARTMENT WITH MOST TURNOVER RATE
SELECT department, TOTAL_COUNT, TERMINATION_COUNT, (TERMINATION_COUNT/TOTAL_COUNT) AS TERMINATION_RATE FROM
 (SELECT department, COUNT(*) AS TOTAL_COUNT,
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0
END) AS TERMINATION_COUNT
FROM hr_records
GROUP BY department)T
ORDER BY TERMINATION_RATE DESC LIMIT 1
;

-- 10. What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) AS COUNT
FROM hr_records
WHERE termdate IS NULL
GROUP BY location_state
ORDER BY COUNT DESC;

-- 11. How has the company's employee count changed over time based on hire and term dates?
SELECT YEAR, HIRES, TERMINATIONS,
(HIRES-TERMINATIONS) AS NET_CHANGE,
ROUND((HIRES-TERMINATIONS)/HIRES * 100, 2) AS NET_CHANGE_PERCENT FROM
(SELECT year(hire_date) AS YEAR, COUNT(*) AS HIRES, 
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS TERMINATIONS
FROM hr_records
GROUP BY YEAR)
T ORDER BY YEAR
;

-- 12. What is the tenure distribution for each department?
SELECT department, ROUND(AVG(DATEDIFF(termdate,hire_date)/365),0) AS AVERAGE_TENURE
FROM hr_records
WHERE termdate IS NOT NULL AND termdate <= curdate()
GROUP BY department;