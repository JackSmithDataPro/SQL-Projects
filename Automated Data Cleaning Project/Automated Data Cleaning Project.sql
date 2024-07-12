# Automated Data Cleaning Project


SELECT *
FROM bakery2.us_household_income;


# Creating an automated data cleaning program
# Using an EVENT 

# Data cleaning steps:

/*
-- Remove Duplicates
DELETE FROM us_household_income_clean 
WHERE 
	row_id IN (
	SELECT row_id
FROM (
	SELECT row_id, id,
		ROW_NUMBER() OVER (
			PARTITION BY id
			ORDER BY id) AS row_num
	FROM 
		us_household_income_clean
) duplicates
WHERE 
	row_num > 1
);

-- Fixing some data quality issues by fixing typos and general standardization
UPDATE us_household_income_clean
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_household_income_clean
SET County = UPPER(County);

UPDATE us_household_income_clean
SET City = UPPER(City);

UPDATE us_household_income_clean
SET Place = UPPER(Place);

UPDATE us_household_income_clean
SET State_Name = UPPER(State_Name);

UPDATE us_household_income_clean
SET `Type` = 'CDP'
WHERE `Type` = 'CPD';

UPDATE us_household_income_clean
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs';
*/

# We need to create a copy of the table to clean

DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_and_Clean_Data;
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN

# CREATE TABLE

	CREATE TABLE IF NOT EXISTS `us_household_income_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `TimeStamp` TIMESTAMP DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# COPY DATA TO NEW TABLE

	INSERT INTO us_household_income_cleaned
	SELECT *, CURRENT_TIMESTAMP
	FROM bakery2.us_household_income;
    
# 1. Remove Duplicates:
    
	DELETE FROM us_household_income_cleaned 
	WHERE 
		row_id IN (
		SELECT row_id
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id, `Timestamp`
				ORDER BY id, `Timestamp`) AS row_num
		FROM 
			us_household_income_cleaned
	) duplicates
	WHERE 
		row_num > 1
	);

# 2. Fixing some data quality issues by fixing typos and general standardisation:

	UPDATE us_household_income_cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE us_household_income_cleaned
	SET County = UPPER(County);

	UPDATE us_household_income_cleaned
	SET City = UPPER(City);

	UPDATE us_household_income_cleaned
	SET Place = UPPER(Place);

	UPDATE us_household_income_cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE us_household_income_cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_household_income_cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';
    
END $$

DELIMITER ;


CALL Copy_and_Clean_Data();
  
SELECT * 
FROM bakery2.us_household_income_cleaned;


# DEBUGGING OR CHECKING STORED PROCEDURE WORKS
# Drop the procedure, check how many duplicates, count of state name and  row_id we have. 
# Then rerun the stored procedure and see if it cleaned the data.

# Before we have run the stored procedure

SELECT row_id, id, row_num
FROM (
	SELECT row_id, id,
		ROW_NUMBER() OVER (
			PARTITION BY id
			ORDER BY id) AS row_num
	FROM 
		us_household_income
	) duplicates
	WHERE 
		row_num > 1;


SELECT COUNT(row_id)
FROM us_household_income;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income
GROUP BY State_Name;


# After we have run the stored procedure

SELECT row_id, id, row_num
FROM (
	SELECT row_id, id,
		ROW_NUMBER() OVER (
			PARTITION BY id
			ORDER BY id) AS row_num
	FROM 
		us_household_income_cleaned
	) duplicates
	WHERE 
		row_num > 1;


SELECT COUNT(row_id)
FROM us_household_income_cleaned;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned
GROUP BY State_Name;


# CREATE EVENT

CREATE EVENT run_data_cleaning 
	ON SCHEDULE EVERY 2 MINUTE
	DO CALL Copy_and_Clean_Data();
    
# This will not work due to our removing duplicates where row_num > 1 parameters
# Every time the procedure runs its creates a copy of the row_num and duplicate id
# We can fix this by:
	# PARTITION BY id, `TimeStamp`
    # ORDER BY id, `Timestamp`) AS row_num
# The TimeStamp is unique and solves this problem
    
# Reset the event to a more realistic time schedule

DROP EVENT run_data_cleaning;
CREATE EVENT run_data_cleaning 
	ON SCHEDULE EVERY 30 DAY
	DO CALL Copy_and_Clean_Data();
    
# Drop the EVENT so that is doesn't keep running in the background

DROP EVENT run_data_cleaning;


# CREATE TRIGGER

DELIMITER $$
CREATE TRIGGER Transfer_Clean_Data
	AFTER INSERT ON bakery2.us_household_income
    FOR EACH ROW
BEGIN
CALL Copy_and_Clean_Data();
END $$
DELIMITER ;
    

INSERT INTO bakery2.us_household_income
(`a`, `b`, `c`)
VALUES
('x','y','z');
    
# It won't work in MySQL without extreme work arounds, something a Data Analyst wouldn't need to do
# Better to use an event 
    
    
    
    
    
    
    
    