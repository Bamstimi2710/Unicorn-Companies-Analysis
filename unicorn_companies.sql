-- initiate the dataset, in order to use the table
USE unicorn_companies;

SELECT * FROM unicorns;
-- a total of 1062 rows was successfully imported into SQL Workbench

SELECT COUNT(DISTINCT Country) FROM unicorns;
-- a total of 46 countries made it to become unicorn

-- Finding out the first 10 company by ROI
SELECT Company, 
		Industry, 
		Valuation_in_full,
        round(((Valuation_in_full-Funding_in_full)/Funding_in_full),1) AS ROI  
FROM unicorns
ORDER BY ROI DESC
LIMIT 10;

-- Finding out the first 10 company by ROI
SELECT Company, 
		Industry, 
		Valuation_in_full,
        round(((Valuation_in_full-Funding_in_full)/Funding_in_full),1) AS ROI  
FROM unicorns
ORDER BY ROI DESC
LIMIT 10;

SELECT ROUND(AVG(Year_count), 2) 
FROM unicorns;

SELECT Company, Year_count, Year_joined, Valuation_in_full
FROM unicorns
WHERE Year_count BETWEEN 0 AND 1
ORDER BY Year_Count;

-- grouping total ROI and Total valuation by Industry
WITH A AS 
(SELECT Company, 
		Industry, 
		Valuation_in_full,
		Year_Joined,
        (Valuation_in_full-Funding_in_full)/Funding_in_full AS ROI  
FROM unicorns)
SELECT Industry,
		SUM(Valuation_in_full) AS total_valuation, SUM(ROI) AS total_roi
FROM A
GROUP BY Industry
ORDER BY total_valuation DESC;


-- finding out the number of companies each industry had
SELECT Industry, COUNT(Company) AS total_company
FROM unicorns
GROUP BY Industry
ORDER BY total_company DESC;


-- companies values above 10 Billion dollars
SELECT Continent, Country, COUNT(Country) AS total_company
FROM unicorns
WHERE Valuation_in_full = '10000000000'
GROUP BY Continent, Country
ORDER BY total_company DESC;

-- total_valuation of each country and their ranks
WITH A AS 
(SELECT Country, SUM(Valuation_in_full) AS total_valuation 
FROM unicorns
GROUP BY Country
ORDER BY total_valuation Desc)
SELECT *, dense_rank() OVER (ORDER BY total_valuation Desc) AS Country_rank
FROM A
LIMIT 5;


WITH B AS
(SELECT  Country, 
		COUNT(Company) AS total_company
FROM unicorns
GROUP BY Country
ORDER BY total_company Desc)
SELECT *,      
		ROUND((total_company/((SELECT COUNT(Company) AS No_of_company FROM unicorns)) * 100),2) AS Percenage,
        dense_rank() OVER( ORDER BY total_company Desc) AS country_rank
FROM B
;

WITH B AS
(SELECT  Industry,
		COUNT(Company) AS total_company
FROM unicorns
GROUP BY Industry
ORDER BY total_company Desc)
SELECT *,      
		round((total_company/((SELECT COUNT(Company) AS No_of_company FROM unicorns)) * 100),2) AS Percenage,
        dense_rank() OVER( ORDER BY total_company Desc) AS Industry_rank
FROM B
;

-- The investor who funded the most Unicorns
SELECT Investors,
		COUNT(Investors) AS No_of_Investment
FROM unicorn_companies.investors
GROUP BY Investors
	ORDER BY No_of_Investment DESC;
    
-- in 2021, 2 africa contries made it to Unicorn, OPAY(Nigeria) and Wave(Senegal) with a valuation of $2 Billion
-- Although there are more Africa countries with company, but they are not ascribed to Africa
SELECT Continent, Country, Valuation FROM unicorns 
WHERE Continent = 'Africa';

SELECT Company, 
		Valuation_in_full, Year_joined
FROM unicorns
ORDER BY Valuation_in_full DESC;

-- Analysis of unicorn_companies based on year_joined
SELECT Year_joined, 
		COUNT(Company) total_company 
FROM unicorns
GROUP BY Year_joined
ORDER BY Year_joined DESC;

-- as at the time of the documentation according to the datasets, 2021 had more company joined the the unicorns 
-- compared to 2022
SELECT Year_joined, 
		COUNT(Company) total_company 
FROM unicorns
GROUP BY Year_joined
ORDER BY total_company DESC;
-- 2021 had more companies joining the unicorns
-- 2021 was a turning point for many countries as close to 50% of unicorns made it unicorn in that year

 
SELECT  
		Year_joined,
        COUNT(Company) total_company
FROM unicorns
WHERE Country = 'United States'
GROUP BY  Year_joined
ORDER BY Year_joined DESC;
-- More than 50% of the US Companies that made it to the unicorns did so in 2021, followed by 2022

SELECT industry, 
        COUNT(Company) total_company
FROM unicorns
WHERE Year_joined = '2021' AND Country = 'United States'
GROUP BY industry
ORDER BY total_company DESC;
-- Internet software & services alongside Fintech topped the list

SELECT  Country,
		Year_joined,
        COUNT(Company) total_company
FROM unicorns
		GROUP BY  Country, Year_joined
HAVING total_company = (SELECT MAX(total_company)
		FROM 
			(SELECT Country, COUNT(Company) AS total_company 
			FROM unicorns
GROUP BY Country, Year_joined) AS tc
WHERE tc.country = unicorns.country
GROUP BY country)
ORDER BY total_company DESC;
-- 2021 was a turning point for many countries as close to 50% of unicorns made it unicorn in that year
-- More than 50% of the US companies on the unicorns reached unicorn in 2021 
