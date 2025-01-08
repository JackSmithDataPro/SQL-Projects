SELECT *
FROM income_data;

# Updatuing state_code column name
ALTER TABLE aus_income_project.income_data RENAME COLUMN `ï»¿state_code` TO `state_code`;

# Checking state_names are all unique
SELECT DISTINCT state_name
FROM income_data;

# Removing plurals and capitalisation from sex
UPDATE income_data
SET sex = CASE
	WHEN sex = 'males' THEN 'male'
    WHEN sex = 'females' THEN 'female'
    ELSE sex
END;

SELECT *
FROM income_data;

# ANALYSIS

# Comparing avg median and avg mean income by sex
SELECT sex, ROUND(AVG(median_income)) median_income, ROUND(AVG(mean_income)) average_income
FROM income_data
GROUP BY sex;

# Comparing avg median and avg mean income by sex by year
SELECT sex, year_ending, ROUND(AVG(median_income)) median_income, ROUND(AVG(mean_income)) average_income
FROM income_data
GROUP BY sex, year_ending
ORDER BY sex, year_ending;

SELECT 
	sex, 
    year_ending, 
    ROUND(AVG(median_income)) median_income, 
    ROUND(AVG(mean_income)) average_income
    
FROM income_data
GROUP BY sex, year_ending
ORDER BY year_ending;


# Comparing avg median and avg mean income by age_range
SELECT age_range, ROUND(AVG(median_income)), ROUND(AVG(mean_income))
FROM income_data
GROUP BY age_range;

# Viewing percentage salary increase

SELECT 
    sex,
    year_ending,
    median_income,
    ROUND(median_income - LAG(median_income) OVER (PARTITION BY sex ORDER BY year_ending), 2) AS salary_increase,
    ROUND(((median_income - LAG(median_income) OVER (PARTITION BY sex ORDER BY year_ending)) / 
            LAG(median_income) OVER (PARTITION BY sex ORDER BY year_ending)) * 100, 2) AS percentage_increase
FROM 

(SELECT 
	sex, 
    year_ending, 
	ROUND(AVG(median_income), 2) AS median_income
FROM income_data
GROUP BY sex, year_ending) AS summary_income
ORDER BY sex, year_ending;



SELECT 
	sex, 
    state_name, 
    ROUND(AVG(median_income),2) median_income_avg, 
    ROUND(AVG(mean_income),2) mean_income_avg,
    ROUND(ABS(AVG(median_income) - AVG(mean_income)),2) mean_median_diff
FROM income_data
GROUP BY state_name, sex
#ORDER BY median_income_avg DESC
;

SELECT ROUND(ABS(AVG(median_income) - AVG(mean_income)),2) mean_median_diff
FROM income_data;

SELECT sex,
	age_range, 
    state_name, 
    ROUND(AVG(median_income)) median_income_avg
FROM income_data
GROUP BY sex, state_name, age_range
ORDER BY median_income_avg DESC
LIMIT 10;

SELECT sex,
	age_range, 
    state_name, 
    ROUND(AVG(median_income)) median_income_avg
FROM income_data
GROUP BY sex, state_name, age_range
ORDER BY median_income_avg ASC
LIMIT 10;