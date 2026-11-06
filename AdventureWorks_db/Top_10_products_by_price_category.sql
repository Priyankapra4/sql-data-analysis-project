-- Categorize products into Expensive, Affordable, and Cheap
-- Retrieve top 10 products per price category using RANK() (skipping ranks on ties)
  
with categorized_products as (
    select 
        productname,
        productprice as productprice,
        case 
            when productprice > 50 then 'expensive'
            when productprice between 20 and 50 then 'affordable'
            else 'cheap'
        end as price_category
    from products
),
ranked_products as (
    select 
        productname,
        productprice,
        price_category,
        rank() over (partition by price_category order by productprice desc) as price_rank
    from categorized_products
)
select 
    productname,
    productprice,
    price_category,
    price_rank
from ranked_products
where price_rank <= 10
order by productprice desc, price_category asc;
