# World Life Expectancy Project (Exploratory Data Analyis)


SELECT * 
FROM world_life_expectancy
;

# Start by looking at the change in life expectancy


SELECT country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) LE_Diff
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0 AND
	MAX(`Life expectancy`) <> 0
ORDER BY LE_Diff DESC
;

# Average Life Expectancy World

SELECT Year, ROUND(AVG(`Life expectancy`),2) AVG_LE
FROM world_life_expectancy
WHERE `Life expectancy` <> 0 
GROUP BY Year
ORDER BY Year
;


SELECT * 
FROM world_life_expectancy
;

# Effect of other factors on Life Expectancy


SELECT Country, ROUND(AVG(`Life expectancy`),1) Avg_LE, ROUND(AVG(GDP),1) GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_LE <> 0
AND GDP > 0	   
ORDER BY GDP DESC
;



SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life Expectancy` ELSE NULL END),2) High_GDP_LE,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life Expectancy` ELSE NULL END),2) Low_GDP_LE	
FROM world_life_expectancy
;


# Looking at Developing/Developed Status effect on Life Expectancy

SELECT * 
FROM world_life_expectancy
;


SELECT Status, ROUND(AVG(`Life Expectancy`),1) Avg_LE
FROM world_life_expectancy
GROUP BY Status
;


SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life Expectancy`),1) Avg_LE
FROM world_life_expectancy
GROUP BY Status
;

# BMI effect on Life Expectancy

SELECT * 
FROM world_life_expectancy
;

SELECT Country, ROUND(AVG(`Life Expectancy`),1) Avg_LE, ROUND(AVG(BMI),1) Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_LE > 0 AND
Avg_BMI > 0
ORDER BY AVG_BMI ASC
;

# BMI data is very inaccurate


# Looking at Adult Mortality

SELECT * 
FROM world_life_expectancy
;

# Using a rolling total, SUM OVER PARITTION BY

SELECT 
	Country, 
    Year, 
    `Life Expectancy`,
    `Adult Mortality`,
    SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;




















