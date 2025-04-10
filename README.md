# Analysis Retail Sales SQL Project

## Project Overview

**Project Title**: Analysis Retail Sales  
**Level**: Beginner  
**Database**: `sql_retail_Analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_retail_Analysis`.
- **Table Creation**: A table named `retail` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
- **Importing data**: 'retail_sales'.csv file is imported.

```sql
CREATE DATABASE sql_retail_Analysis;

CREATE TABLE retail
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

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset. 
- **Deleting null values**:if any null values are found deleting the null record.

```sql
SELECT COUNT(*) FROM retail;
SELECT COUNT(DISTINCT customer_id) FROM retail;
SELECT DISTINCT category FROM retail;

SELECT * FROM retail
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND month(sale_date) = 11
  AND year(sale_date) = 2022;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail
GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_transaction
FROM retail
GROUP 
    BY 
    category,
    gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
WITH monthly_sale as(
SELECT floor(avg(total_sale)) as avg_sales , month(sale_date) as month_sale,year(sale_date) as year_sale
FROM retail
GROUP
  By month_sale,year_sale
),
ranked_sales AS (
  SELECT *,
         RANK() OVER (PARTITION BY year_sale ORDER BY avg_sales DESC) AS sales_rank
  FROM monthly_sale
)
SELECT  year_sale,month_sale, avg_sales
FROM ranked_sales
WHERE sales_rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique
FROM retail
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN hour(sale_time) < 12 THEN 'Morning'
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
```

11. **Q.11 Which category has the highest average sale price?**:
```sql
SELECT category, AVG(total_sale / quantity) AS avg_price
FROM retail
GROUP BY category
ORDER BY avg_price DESC
LIMIT 1;
```

12. **Determine the percentage contribution of each category to overall sales?**:
```sql
SELECT 
    category,
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail),2) AS percentage_contribution
FROM retail
GROUP BY category
ORDER BY percentage_contribution DESC;

```

13. **Q.13 Calculate the customer lifetime value (total amount spent) for each customer?**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) AS lifetime_value
FROM retail
GROUP BY customer_id
ORDER BY customer_id ;
```


## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing , Beauty and Electronics.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
 - **High Revenue Contributors**: Specific queries identify top customers by total sales, providing clarity on which customers contribute most to revenue.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Sales Trends & Peaks**: Monthly and daily sales trends are explored, including identifying best-selling days, months, or shifts, which can be used for planning promotions and inventory.


## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project provides a solid foundation in SQL for data analysts, encompassing key areas such as database creation, data cleaning, exploratory analysis, and business-oriented querying. The analysis delivers valuable insights into sales performance, customer behavior, product trends, and seasonal patterns—enabling data-driven decision-making across various aspects of the business.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `sql_retail_p1` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author 

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.


Thank you !
