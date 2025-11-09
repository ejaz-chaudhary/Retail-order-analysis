use retail_order;
SELECT * FROM retail_order.cleaned_retail_order;

-- 1 .  top 10 highest revenue generating product
SELECT 
    product_id, SUM(sale_price) AS sales
FROM
    cleaned_retail_order
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

-- 2. top 5 highest selling product in each region 
with cte as (
SELECT  region,
    product_id, SUM(sale_price) AS sales
FROM
    cleaned_retail_order
GROUP BY region, product_id)
select * from (
select *,
row_number() over(partition by region ORDER BY  sales desc) as rn
 from cte ) A
 where rn<6;
 
 -- 3.  find month over month growrtth camparision for year 22 and 23 sales
 with cte as (
 select  year(order_date) as order_year, month(order_date) as order_month, 
 sum(sale_price) as sales
 from cleaned_retail_order
 group by year(order_date), month(order_date)
 -- order by year(order_date), month(order_date)
 )
select order_month ,
sum( case when order_year = 2022 then sales else 0 end ) as sales_2022,
sum( case when order_year = 2023 then sales else 0 end ) as sales_2023
from cte
group by order_month
order by order_month;
 
 -- 4. for each category which have highest sales
 with cte as (
 select  category,  year(order_date),month(order_date) as order_year_month, sum(sale_price) as sales
 from cleaned_retail_order
 group by category,year(order_date), month(order_date)
 order by category,year(order_date), month(order_date)
 )
 select * from ( 
 select *,
 row_number() over(partition by  category  order by sales desc) as rn
 from cte ) a
 where rn = 1;
 
 -- 5. which sub category has highest growth by profit in 2023 from 2022
 
 
  with cte as (
 select sub_category,  year(order_date) as order_year, 
 sum(sale_price) as sales
 from cleaned_retail_order
 group by sub_category, year(order_date) 
 ),
 cte2 as (
select sub_category ,
sum( case when order_year = 2022 then sales else 0 end ) as sales_2022,
sum( case when order_year = 2023 then sales else 0 end ) as sales_2023
from cte
group by sub_category
order by sub_category
)
select *,
(sales_2023-sales_2022)*100/sales_2022 as growth_percent
from cte2
order by (sales_2023-sales_2022)*100/sales_2022  desc;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

