create table retail_sales(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(20),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float

);

select count(*) from retail_sales;
--Data Cleaning
select * from retail_sales
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL 
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL 
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Deleting null data 
delete from retail_sales
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL 
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL 
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
--Data Exploration

--How many sales we have 
select count(*) as total_sales from retail_sales;

--How many unique customes we have 
select count(distinct customer_id) as unique_customer from retail_sales;

select distinct category from retail_sales;

--Data analytics & BUsiness key Problems & answers

-- My Analysis & Findings
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

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select *
from retail_sales
where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *
from retail_sales
where
	category='Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND 
	quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,SUM(total_sale) as net_sales
from retail_sales
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select ROUND(avg(age)) as average_age
from retail_sales
where category='Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales
where total_sale >1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender,category,count(*) as total_trans
from retail_sales 
	group by gender,category
		order by 2;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select
	year,month,avg_sales
from
(
	select 
		EXTRACT(YEAR from sale_date) as year,
		EXTRACT(MONTH from sale_date) as month,
		avg(total_sale) as avg_sales,
		rank() over(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY avg(total_sale) DESC) as rank
	from retail_sales
	GROUP by 1,2
) as t1
where rank=1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
	customer_id,
	sum(total_sale) as tatal_sales
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(distinct customer_id)
from retail_sales
group by 1;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
as
(
select *,
	case
		WHEN EXTRACT(hour from sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(hour from sale_time) BETWEEN 12 and 17 THEN 'Afternoor'
		ELSE 'Evening'
	END as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift


--End of the project--