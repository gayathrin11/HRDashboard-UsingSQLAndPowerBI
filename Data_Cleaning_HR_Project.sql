-- SQL DATA CLEANING OF HUMAN RESOURCES DATASET

SELECT * FROM hr_records;

-- Rename and change the data type of the id column
ALTER TABLE hr_records
CHANGE ï»¿id employee_id VARCHAR(20) NULL;

-- Standardizing data
UPDATE hr_records SET birthdate = CASE
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr_records
MODIFY COLUMN birthdate date;

UPDATE hr_records SET hire_date = CASE
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr_records
MODIFY COLUMN hire_date date;

UPDATE hr_records SET termdate = DATE(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

UPDATE hr_records 
SET termdate = NULL
WHERE termdate = '';

ALTER TABLE hr_records
MODIFY COLUMN termdate date;

-- Adding an additional column - age with the help of other existing columns
ALTER TABLE hr_records
ADD COLUMN age INT ;

UPDATE hr_records
SET age = timestampdiff(YEAR, birthdate, curdate());

-- Removing unwanted rows
SELECT COUNT(*) FROM hr_records WHERE AGE<18 ;

DELETE FROM hr_records WHERE AGE<18 ;

-- Another way is handling the negative values without deleting them
-- This can be done by using datesub and calculating the right value for birthdate
UPDATE hr_records 
SET birthdate = date_sub(birthdate, INTERVAL 100 YEAR)
WHERE birthdate between '2065-01-01' AND '2070-01-01' ;

-- Data cleaning done.