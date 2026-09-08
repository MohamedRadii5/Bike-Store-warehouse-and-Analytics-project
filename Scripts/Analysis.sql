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


