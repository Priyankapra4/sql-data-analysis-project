-- Rank top 5 sales days in revenue for each subcategory in 2020
-- Calculate revenue as (productprice * orderquantity) using dense_rank()

with ranked_sales as (
    select sc.subcategoryname, s.orderdate,
    sum(p.productprice * s.orderquantity) as daily_revenue,
    dense_rank() over (partition by sc.subcategoryname order by sum(p.productprice * s.orderquantity) desc) as revenue_rank
    from sales s join products p on s.product_id = p.product_id
    join subcategories sc on p.subcategory_id = sc.subcategory_id
    where extract(year from s.orderdate) = 2020
    group by sc.subcategoryname, s.orderdate
)
select subcategoryname, orderdate, daily_revenue, revenue_rank
from ranked_sales
where revenue_rank <= 5
order by 3 desc, 1 asc;
