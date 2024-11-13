# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**SQL Platform**: MSSQL SERVER

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided data.
2. **Data Cleaning**: Identify and remove records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. DATA CLEANING AND EXPLORATION

- **Record Count**: Determine the total number of records in the dataset.
SELECT COUNT(*) FROM retail_sales;

- **Customer Count**: Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

- **Category Count**: Identify all unique product categories in the dataset.
SELECT DISTINCT category FROM retail_sales;


- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-**DROPPING NULLS
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-**REPLACING NULLS 
UPDATE retail_sales
SET age = (SELECT ROUND(AVG(age), 0) FROM retail_sales WHERE AGE IS NOT NULL)
WHERE age IS NULL;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';
```

3. **Write a SQL query to calculate each category's total sales (total_sale).**:
```sql
SELECT category, 
		SUM(total_sale) NET_SALE
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category, 
		ROUND(AVG(age), 0) AVG_AGE
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale exceeds 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category, gender, COUNT(*) TRANSACTION_BY_GENDER_N_CATEGORY
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT TOP 5 customer_id, 
	   SUM(total_sale) TOTAL_SALES
FROM retail_sales
GROUP BY customer_id
ORDER BY TOTAL_SALES DESC;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT customer_id) UNIQUE_CUSTOMERS
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.


