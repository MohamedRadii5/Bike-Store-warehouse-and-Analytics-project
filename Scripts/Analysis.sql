### Explaination
select * from Gold.dim_customers;
select * from Gold.dim_products;
select * from Gold.fact_sales;

--=======================================================================

### KPIs

-- Total Reveneu
Select 
SUM(price) TOTAL_SALES
From Gold.fact_sales
---------------------------------------------
-- No.of Orders
Select 
Count(order_number) Orders
From Gold.fact_sales
---------------------------------------------
-- No.of Customers
 Select 
Count(customer_key) Customers
From Gold.dim_customers
---------------------------------------------
-- No.of sold Quantities 
Select 
SUM(quantity) Quantities
From Gold.fact_sales
---------------------------------------------
-- AVG delivery time By Days
Select 
AVG(Datediff(day,order_date, shipping_date)) Avg_Delivery_Days
From Gold.fact_sales

 --=======================================================================

### Analytics
	
-- trend Analysis by Order Date
select 
		order_date,
		Sum(price) Sales
from Gold.fact_sales
Where order_date is NOT NULL
Group by order_date
Order by order_date asc
---------------------------------------------
-- Top countries Sales ###
Select 
		country,
		Sum(price) Sales
From Gold.dim_customers C
JOIN Gold.fact_sales S
		ON C.customer_key = S.customer_key
Group by country
Order by Sales DESC
---------------------------------------------
-- Top 10 Customer Sales
Select top 10
		first_name+' '+last_name AS Customer_name,
		Sum(price) Sales
From Gold.dim_customers C
JOIN Gold.fact_sales S
		ON C.customer_key = S.customer_key
Group by first_name+' '+last_name
Order by Sales DESC
---------------------------------------------
-- Order Count per Customer by Age 
Select 
		C.customer_key,
		Datediff(year, C.birth_date, GETDATE()) -
		CASE 
				WHEN DATEADD(YEAR, DATEDIFF(YEAR, C.birth_date,  GETDATE()), C.birth_date) > GETDATE()
				THEN 1
				ELSE 0
		END AS Age,
		COUNT(S.order_number) AS orders
From Gold.dim_customers C
JOIN Gold.fact_sales S
		ON C.customer_key = S.customer_key
Group by
		C.customer_key,
		C.birth_date
Order by customer_key ASC
---------------------------------------------
-- Order Count per Customer by Gender and Marital Status
Select 
		C.gender,
		C.marital_status,
		COUNT(S.order_number) AS orders
From Gold.dim_customers C
LEFT JOIN Gold.fact_sales S
		ON C.customer_key = S.customer_key
Group by gender, marital_status
Order by orders DESC
---------------------------------------------
-- Category Sales
SELECT 
		P.category,
		SUM(S.price) AS Total_Sales
FROM Gold.dim_products P
JOIN Gold.fact_sales S
ON P.product_key = S.product_key
Group by category
Order By Total_Sales DESC
---------------------------------------------
-- Sub Category Sales
SELECT 
		P.subcategory,
		SUM(S.price) AS Total_Sales
FROM Gold.dim_products P
JOIN Gold.fact_sales S
ON P.product_key = S.product_key
Group by subcategory
Order By Total_Sales DESC
---------------------------------------------
-- Top 15 Products 
SELECT TOP 15
		Row_Number() Over (Order by SUM(S.price) DESC) AS Rank,
		P.product_name,
		SUM(S.price) AS Total_Sales
FROM Gold.dim_products P
JOIN Gold.fact_sales S
		ON P.product_key = S.product_key
Group by product_name
ORDER BY Total_Sales DESC;
---------------------------------------------
-- Top 10 Customers
SELECT TOP 10
		Row_Number() Over (Order by SUM(S.price) DESC) AS Rank,
		C.customer_number,
		first_name+' '+last_name CustomerName,
		SUM(S.price) AS Total_Sales
FROM Gold.dim_customers C
JOIN Gold.fact_sales S
		ON C.customer_key = S.customer_key
Group by C.first_name+' '+last_name, customer_number
ORDER BY Total_Sales DESC;
---------------------------------------------
-- Product Line 
SELECT 
		Row_Number() Over (Order by COUNT(S.order_number) DESC) AS Rank,
		P.product_line,
		COUNT(S.order_number) AS Orders
FROM Gold.dim_products P
JOIN Gold.fact_sales S
		ON P.product_key = S.product_key
Group by product_line
ORDER BY Orders DESC;
