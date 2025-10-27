-- Create Table
create table retail_sales(
    transactions_id	INT,
	sale_date DATE,	
	sale_time TIME,	
	customer_id	INT,
	gender VARCHAR(15),	
	age	INT,
	category VARCHAR(15),
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);
ALTER TABLE retail_sales
ADD CONSTRAINT retail_sales_pk PRIMARY KEY (transactions_id);


select * from retail_sales;
select 
    count(*) 
from retail_sales;

select * from retail_sales 
limit 10;

-- Data Cleaning
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
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
Delete from retail_sales
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
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

select count(*) from retail_sales;

-- Data Exploration

--How many sales we have?
select count(*) as total_sales from retail_sales;
--How many unique customers we have?
select count(distinct customer_id) from retail_sales;
--How many categories we have?
select distinct category from retail_sales;Q1

-- Data Analysis & Business key Problems & Answers

--My Analysis & Findings

--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 or more than 4 in the month of Nov-2022
--Q3.Write a SQL query to calculate the total sales(total_sale) for each category?
--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000?
--Q6.Write a SQL query to find the total number of transactions(transaction_id)made by each gender in each category?
--Q7.Write a SQL query to calculate the average sale for each month.Find out best selling month in each year?
--Q8.Write a SQL query to find the top 5 customers based on the highest total sales?
--Q9.Write a SQL query to find the number of unique customers who purchased items for each category?
--Q10.Write a SQL query to create each shift and number of orders(Example Morning<=12, Afternoon Between 12 & 17, Evening >17)


--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * 
from retail_sales
where sale_date = '2022-11-05';


--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 or more than 4 in the month of Nov-2022
select *
from retail_sales
where 
    category = 'Clothing' 
	and 
	to_char(sale_date,'YYYY-MM') = '2022-11'
	and
	quantity >= 4;

--Q3.Write a SQL query to calculate the total sales(total_sale) for each category?
select 
    category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales 
group by 1;


--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
select 
   ROUND(avg(age), 2) as avg_age
from retail_sales 
where category = 'Beauty';


--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000?
select * from retail_sales 
where total_sale > 1000;

--Q6.Write a SQL query to find the total number of transactions(transaction_id)made by each gender in each category?
select count(transactions_id)as total_transactions,gender,category from retail_sales group by 2,3;

--Q7.Write a SQL query to calculate the average sale for each month.Find out best selling month in each year?
select 
    year,
	month,
	avg_sale
From
(
select 
    extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	Rank() over(partition by extract(year from sale_date)order by avg(total_sale)desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1;


--Q8.Write a SQL query to find the top 5 customers based on the highest total sales?
select 
    customer_id,
	sum(total_sale)as total_sales 
from retail_sales 
group by 1
order by 2 desc
limit 5;

--Q9.Write a SQL query to find the number of unique customers who purchased items for each category?

select 
    count(distinct customer_id) as unique_customer, 
	category 
from retail_sales 
group by 2;

--Q10.Write a SQL query to create each shift and number of orders(Example Morning<=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale 
as(
select *,
    case
	    when extract(hour from sale_time)<12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select 
   shift, 
   count(*) as total_orders 
from hourly_sale 
group by shift;

--End of Project
