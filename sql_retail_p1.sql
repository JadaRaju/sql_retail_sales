Create database sql_retail_Analysis;
USE sql_retail_Analysis;
CREATE TABLE retail
(
 transactions_id INT PRIMARY KEY,
 sale_date DATE,
 sale_time	TIME,
 customer_id INT,
 gender varchar(10),
 age INT,
 category varchar(30),
 quantity INT,
 price_per_unit	FLOAT,
 cogs FLOAT,
 total_sale FLOAT
);

-- Importing csv file
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\retail_sales.csv'
INTO TABLE retail
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(transactions_id, @sale_date, sale_time, customer_id, gender, @age, category, @quantity, @price_per_unit, @cogs, @total_sale)
SET 
  sale_date = STR_TO_DATE(@sale_date, '%Y-%m-%d'),
  age = NULLIF(@age, ''),
  quantity = NULLIF(@quantity, ''),
  price_per_unit = NULLIF(@price_per_unit, ''),
  cogs = NULLIF(@cogs, ''),
  total_sale = NULLIF(
    REGEXP_REPLACE(REPLACE(TRIM(@total_sale), ',', ''), '[^0-9.]', ''),
    ''
  );
  
  SELECT * FROM retail;
  
-- Data Cleaning
SELECT * FROM retail
WHERE transactions_id IS NULL;

SELECT * FROM retail
WHERE sale_date IS NULL;

SELECT * FROM retail
WHERE sale_time IS NULL;

-- Delete null values
DELETE FROM retail
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
 
   -- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail;

-- How many unique customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail;

-- How many unique category we have ?
SELECT DISTINCT category FROM retail; 

     -- Data Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q.11 Which category has the highest average sale price?
-- Q.12 Determine the percentage contribution of each category to overall sales?
-- Q.13 Calculate the customer lifetime value (total amount spent) for each customer?



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05?
SELECT * 
FROM retail
WHERE sale_date="2022-11-05"; 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022?
SELECT transactions_id 
FROM retail
WHERE category='Clothing' 
   AND quantity >= 4
   AND month(sale_date) = 11
   AND year(sale_date) = 2022;
   
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category?
SELECT category, SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
SELECT 
    ROUND(AVG(age),2) AS avg_age
FROM retail    
WHERE category='Beauty';    

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000?
SELECT *
FROM retail
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?
SELECT gender,category,SUM(transactions_id) AS total_transactions 
FROM retail
GROUP BY gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?
WITH monthly_sale AS(
SELECT floor(AVG(total_sale)) AS avg_sales ,
		month(sale_date) AS month_sale,
	    year(sale_date) AS year_sale
FROM retail
GROUP BY month_sale,year_sale
),
ranked_sales AS (
  SELECT *,
         RANK() OVER (PARTITION BY year_sale ORDER BY avg_sales DESC) AS sales_rank
  FROM monthly_sale
)
SELECT  year_sale,month_sale, avg_sales
FROM ranked_sales
WHERE sales_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id ,sum(total_sale) AS total_sale
FROM retail
GROUP BY 1
order by total_sale desc
limit 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category?
SELECT category,count(distinct customer_id) AS cnt_unqiue
FROM retail
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)?
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN  hour(sale_time) < 12 THEN 'Morning'
        WHEN hour(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- Q.11 Which category has the highest average sale price?
SELECT category, AVG(total_sale / quantity) AS avg_price
FROM retail
GROUP BY category
ORDER BY avg_price DESC
LIMIT 1;

-- Q.12 Determine the percentage contribution of each category to overall sales?
SELECT 
    category,
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail),2) AS percentage_contribution
FROM retail
GROUP BY category
ORDER BY percentage_contribution DESC;

-- Q.13 Calculate the customer lifetime value (total amount spent) for each customer?
SELECT 
    customer_id,
    SUM(total_sale) AS lifetime_value
FROM retail
GROUP BY customer_id
ORDER BY customer_id ;


   -- END OF PROJECT 