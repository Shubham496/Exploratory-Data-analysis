-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;


-- explore all the columns in database 
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';


-- Exploring all countries

SELECT DISTINCT country FROM gold.dim_customers;

-- Exploring all the categories 
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
order by 1,2,3



-- finding date of first and last order

SELECT 
MIN(order_date) as first_order_date, 
MAX(order_date) as last_order_date,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as timespan
FROM gold.fact_sales;

--- finding youngest and oldest coustomer
SELECT 
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(YEAR, MIN(birthdate), GETDATE()) as oldest_age,
MAX(birthdate) as youngest_birthdate,
DATEDIFF(YEAR, MAX(birthdate), GETDATE()) as youngest_age
FROM gold.dim_customers;



-- Finding the Total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- finding how many items sold
SELECT SUM(quantity) AS total_amount FROM gold.fact_sales;


-- finding average selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales

-- finding the total number of orders
SELECT COUNT(order_number) AS  total_orders FROM gold.fact_sales;
SELECT COUNT(distinct order_number) AS  total_orders FROM gold.fact_sales;


-- finding the total number of products
SELECT COUNT(product_key) AS TOTAL_PRODUCTS FROM gold.dim_products;


-- finding the total number of customers
SELECT COUNT(customer_key) AS customer_base FROM gold.dim_customers

-- no of customers that has placed orders
SELECT COUNT(DISTINCT customer_key) AS active_users FROM gold.fact_sales







SELECT 'Total Sales' as measure_name, SUM(sales_amount) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total quantity' ,	SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'average_price' ,AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'total_orders', COUNT(order_number) FROM gold.fact_sales
UNION ALL 
SELECT 'total_orders', COUNT(distinct order_number)  total_orders FROM gold.fact_sales
UNION ALL
SELECT 'TOTAL_PRODUCTS', COUNT(product_key) FROM gold.dim_products
UNION ALL 
SELECT 'active_users',  COUNT(DISTINCT customer_key) FROM gold.fact_sales;






-- total customers by countries
SELECT 
COUNT(*) AS TOTAL , country 
FROM gold.dim_customers
GROUP BY country
ORDER BY TOTAL;

-- total customers by gender
SELECT 
COUNT(*) AS 'TOTAL', gender 
FROM gold.dim_customers
GROUP BY gender;

-- total products by category
SELECT COUNT(*) AS 'TOTAL', category FROM gold.dim_products
GROUP BY category ORDER BY TOTAL DESC;

-- what is average costs in each category
SELECT AVG(cost) 'AVG COST', category FROM gold.dim_products
GROUP BY category;

-- what is total reventure generated for each category 
SELECT SUM(sales_amount) TOTAL, category
FROM gold.fact_sales AS S
LEFT JOIN gold.dim_products AS P
ON P.product_key = S.product_key
GROUP BY category;


-- find total revenue genrated by each customer
SELECT * FROM (
SELECT customer_key, SUM(sales_amount) AS TOTAL
FROM gold.fact_sales
GROUP BY customer_key
) AS ABC JOIN gold.dim_customers AS C ON C.customer_key= ABC.customer_key


-- what is distribution of sold items across countries
SELECT SUM(TOTAL), country FROM (
SELECT customer_key, SUM(quantity) AS TOTAL
FROM gold.fact_sales
GROUP BY customer_key
) AS ABC JOIN gold.dim_customers AS C ON C.customer_key= ABC.customer_key
GROUP BY country;


-- TOP 5 PRODUCTS

SELECT TOP 5
P.product_name,
SUM(F.sales_amount) TOTAL 
FROM gold.fact_sales AS F
LEFT JOIN gold.dim_products AS P
ON P.product_key = P.product_key
GROUP BY P.product_name
ORDER BY TOTAL DESC;




-- WORST PRODUCTS
SELECT TOP 5
P.product_name,
SUM(F.sales_amount) TOTAL 
FROM gold.fact_sales AS F
LEFT JOIN gold.dim_products AS P
ON P.product_key = P.product_key
GROUP BY P.product_name
ORDER BY TOTAL ASC
