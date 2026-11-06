-- Identify products peaking in Q4 2020 by sales volume
-- Rank products within their price range using RANK()

select p.productname, sum(s.orderquantity) as total_sales,
    case 
        when p.productprice > 30 then 'high'
        when p.productprice between 20 and 30 then 'medium'
        else 'low'
    end as price_range,
    rank() over (partition by 
        case 
            when p.productprice > 30 then 'high'
            when p.productprice between 20 and 30 then 'medium'
            else 'low'
        end 
        order by sum(s.orderquantity) desc
    ) as rank
from sales s join products p on s.product_id = p.product_id
where extract(quarter from s.orderdate) = 4 
  and extract(year from s.orderdate) = 2020
group by p.productname, p.productprice
order by 2 desc, 1 asc;
