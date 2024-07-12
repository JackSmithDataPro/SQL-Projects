# US Household Income Data Exploratory Data Analysis

SELECT * 
FROM us_household_income
;

SELECT * 
FROM us_household_income_statistics
;

# Good to check if our queries are making logical sense when we run them
# I.e. Texas has the highest land area

SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
;

SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
;

# Identify the top ten largest states by land:


SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;


# And by water:

SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Joining the data

SELECT * 
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
;


SELECT inc.State_Name, County, `Type`, `Primary`, Mean, Median
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
;

# Finding the AVG of the Average income

SELECT inc.State_Name, ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
GROUP BY inc.State_Name
ORDER BY 2 DESC
LIMIT 5;

# Finding the AVG of the Median income

SELECT inc.State_Name, ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
GROUP BY inc.State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Looking into Type

SELECT `Type`, COUNT(`Type`), ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
GROUP BY `Type`
ORDER BY 3 DESC
;

SELECT `Type`, COUNT(`Type`), ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
GROUP BY `Type`
ORDER BY 4 DESC
;


SELECT *
FROM us_household_income
WHERE `Type` = 'Community'
;


SELECT `Type`, COUNT(`Type`), ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
;



SELECT inc.State_Name, City, ROUND(AVG(Mean),1)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
GROUP BY inc.State_Name, City
ORDER BY ROUND(AVG(Mean),1) Desc
;



SELECT inc.State_Name, City, ROUND(AVG(Median),1)
FROM us_household_income inc
JOIN us_household_income_statistics incs
	ON inc.id = incs.id
GROUP BY inc.State_Name, City
ORDER BY ROUND(AVG(Median),1) Desc
;























