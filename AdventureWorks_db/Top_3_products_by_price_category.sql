-- categorize products into expensive, affordable, and cheap
-- retrieve top 3 products from each category using dense_rank()

with categorized_products as (
    select productname, productprice ,
        case 
            when productprice > 50 then 'expensive'
            when productprice between 20 and 50 then 'affordable'
            else 'cheap'
        end as price_category
    from products
),
ranked_products as (
    select productname, productprice, price_category,
    dense_rank() over (partition by price_category order by productprice desc) as price_rank
    from categorized_products
)
select productname, productprice, price_category, price_rank
from ranked_products
where price_rank <= 3
order by productprice desc, price_category asc;
