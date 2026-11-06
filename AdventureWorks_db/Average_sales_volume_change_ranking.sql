-- Average Sales Volume & Change Ranking (First vs Second Half)
-- Calculate average sales volume for each product (First Half vs Second Half)
-- Rank products based on change in sales volume (no gaps on ties).

with firsthalf as (
    select product_id, avg(orderquantity) as avg_quantity_first_half
    from sales
    where extract(month from orderdate) between 1 and 6
    group by product_id
),
secondhalf as (
    select product_id, avg(orderquantity) as avg_quantity_second_half
    from sales
    where extract(month from orderdate) between 7 and 12
    group by product_id
)
select  f.product_id, 
round(f.avg_quantity_first_half, 2) as avg_quantity_first_half, 
round(s.avg_quantity_second_half, 2) as avg_quantity_second_half,
round(s.avg_quantity_second_half - f.avg_quantity_first_half, 2) as difference_in_both_half,
dense_rank() over(order by round(s.avg_quantity_second_half - f.avg_quantity_first_half, 2) desc) as rank_change
from firsthalf f join secondhalf s on f.product_id = s.product_id
order by 4 desc, f.product_id;
