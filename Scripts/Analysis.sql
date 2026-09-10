### Explaination
select * from Gold.dim_customers;
select * from Gold.dim_products;
select * from Gold.fact_sales;
----------------------------------------------------
### requierments   
-- trend analysis (done)
-- top countrieas (done)
-- top cust (done)
-- gender
-- Age
-- top cat & sub_cat
-- product line
-- top 10 customers
-- KPIs
-----------------------------------------------------
-- trend Analysis by Order Date
select 
		order_date,
		Sum(price) Sales
from Gold.fact_sales
Where order_date is NOT NULL
Group by order_date
Order by order_date asc

-- Top countries Sales ###
Select 
		country,
		Sum(price) Sales
From Gold.dim_customers C
JOIN Gold.fact_sales S
ON C.customer_key = S.customer_key
Group by country
Order by Sales DESC

-- Top 10 Customer Sales
Select top 10
		first_name+' '+last_name AS Customer_name,
		Sum(price) Sales
From Gold.dim_customers C
JOIN Gold.fact_sales S
ON C.customer_key = S.customer_key
Group by first_name+' '+last_name
Order by Sales DESC


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


-- Order Count per Customer by Gender
Select 
		C.gender,
		COUNT(S.order_number) AS orders
From Gold.dim_customers C
LEFT JOIN Gold.fact_sales S
		ON C.customer_key = S.customer_key
Group by gender
Order by orders DESC

