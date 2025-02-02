-- Data Acquisition and Import
LOAD DATA INFILE 'path/to/world_bank_debt_data.csv'
INTO TABLE debt_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Exploratory Data Analysis (EDA)
DESCRIBE debt_data;
SELECT * FROM debt_data LIMIT 5;
SELECT * FROM debt_data WHERE total_debt IS NULL;

-- Filter Developing Countries
CREATE TABLE developing_countries AS
SELECT *
FROM debt_data
WHERE country_classification = 'Developing';

-- Calculate Total Debt
SELECT SUM(total_debt) AS total_debt_trillion
FROM developing_countries;

-- Largest Debtors
SELECT country, total_debt
FROM developing_countries
ORDER BY total_debt DESC
LIMIT 5;

-- Analyze Debt Categories
SELECT debt_category, SUM(amount) AS total_amount
FROM developing_countries
GROUP BY debt_category
ORDER BY total_amount DESC;

-- Find Common Debt Categories Shared by All Countries
SELECT debt_category, COUNT(DISTINCT country) AS country_count
FROM developing_countries
GROUP BY debt_category
HAVING country_count = (SELECT COUNT(DISTINCT country) FROM developing_countries);

-- Summarize Insights and Key Trends
SELECT COUNT(DISTINCT country) AS total_countries, 
       SUM(total_debt) AS total_global_debt
FROM developing_countries;

SELECT country, debt_category, SUM(amount) AS total_debt_by_category
FROM developing_countries
GROUP BY country, debt_category
ORDER BY total_debt_by_category DESC;
