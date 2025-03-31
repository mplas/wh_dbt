with
    customers as (select * from {{ ref("stg_jaffle_shop__customers") }}),

    orders as (select * from {{ ref("stg_jaffle_shop__orders") }}),

    customer_orders as (

        select
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders

        from orders

        group by customer_id

    ),

    final as (
        select
            cst.customer_id,
            cst.first_name,
            cst.last_name,
            cst_ord.first_order_date,
            cst_ord.most_recent_order_date,
            coalesce(cst_ord.number_of_orders, 0) as number_of_orders
        from customers cst
        left join customer_orders cst_ord on cst.customer_id = cst_ord.customer_id
    )
select *
from final
