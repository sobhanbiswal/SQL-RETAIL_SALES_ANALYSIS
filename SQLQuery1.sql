--SQL RETAIL ANALYSIS PROJECT - P1
CREATE DATABASE sql_project_p1;

--CREATE TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		(
				transactions_id	INT,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(10),
				age	INT,
				category VARCHAR(50),
				quantiy FLOAT,
				price_per_unit FLOAT,	
				cogs FLOAT,
				total_sale FLOAT
	   	 );

SELECT * FROM retail_sales;

--DATA CLEANING

SELECT COUNT(*) TOTAL_ROWS FROM retail_sales; -- TOTAL NO. OF ROWS

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date is NULL
	OR sale_time is NULL
	OR age IS NULL
	OR customer_id is NULL
	OR gender is NULL								----CHECKING NULLS
	OR category is NULL
	OR quantiy is NULL
	OR price_per_unit is NULL
	OR cogs is NULL
	OR total_sale is NULL;


DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date is NULL
	OR sale_time is NULL
	OR customer_id is NULL
	OR gender is NULL						----REMOVE ROWS AS LESS NUMBER OF ROWS NEED TO BE DROPPED
	OR category is NULL
	OR quantiy is NULL
	OR price_per_unit is NULL
	OR cogs is NULL
	OR total_sale is NULL;


UPDATE retail_sales
SET age = (SELECT ROUND(AVG(age), 0) FROM retail_sales WHERE AGE IS NOT NULL)   ----REPLACING OF NULLS FOR AGE BY USING MEAN AS IT WON'T AFFECT THE BUSINESS STATEMENT MAINTAINING INTEGRITY OF DATA
WHERE age IS NULL;



--DATA EXPLORATION:
----HOW MANY SALES DONE?
SELECT COUNT(*) AS TOTAL_SALES 
FROM retail_sales;

----HOW MANY CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) TOTAL_CUSTOMERS 
FROM retail_sales;

----HOW MANY CATEGORIES WE HAVE?
SELECT COUNT(DISTINCT category) NO_OF_CATEGORIES 
FROM retail_sales;

----SHOW DISTINCT CATEGORIES
SELECT DISTINCT category 
FROM retail_sales;

--DATA ANALYSIS AND BUSINESS PROPLEMS:
----Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

----Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';

----Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, 
		SUM(total_sale) NET_SALE
FROM retail_sales
GROUP BY category;

----Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT category, 
		ROUND(AVG(age), 0) AVG_AGE
FROM retail_sales
--WHERE category = 'Beauty'
GROUP BY category;

----Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

----Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender, COUNT(*) TRANSACTION_BY_GENDER_N_CATEGORY
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

----Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT YEAR, MONTH, AVG_SALE
FROM 
	(   SELECT FORMAT(sale_date, 'yyyy') YEAR,
			   FORMAT(sale_date, 'MMM') MONTH,
			   ROUND(AVG(total_sale), 2) AVG_SALE,
			   RANK() OVER(PARTITION BY FORMAT(sale_date, 'yyyy') ORDER BY AVG(total_sale) DESC) RANK  
		FROM retail_sales
		GROUP BY FORMAT(sale_date, 'yyyy'), FORMAT(sale_date, 'MMM')
	) T1
WHERE RANK = 1;

----Write a SQL query to find the top 5 customers based on the highest total sales:

SELECT TOP 5 customer_id, 
	   SUM(total_sale) TOTAL_SALES
FROM retail_sales
GROUP BY customer_id
ORDER BY TOTAL_SALES DESC;

----Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT customer_id) UNIQUE_CUSTOMERS
FROM retail_sales
GROUP BY category;

----Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH HOURLY_SALES AS
	(
		SELECT *, 
				CASE 
					WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
					WHEN DATEPART(HOUR, sale_time) > 17 THEN 'Evening'
					ELSE 'Afternoon'
				END SHIFT
		FROM retail_sales
	)

SELECT SHIFT, COUNT(transactions_id)NO_OF_TRANSACTION
FROM HOURLY_SALES
GROUP BY SHIFT;
/**                                           END OF PROJECT                                          **/