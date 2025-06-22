WITH 

stg_orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

stg_customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

stg_stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

joined_tables AS (
    SELECT 
        stg_orders.order_id,
        stg_orders.ordered_at,
        stg_orders.customer_id,
        stg_customers.customer_name,
        stg_orders.store_id,
        stg_stores.location_name,
        stg_stores.opening_date
    FROM stg_orders
    LEFT JOIN stg_customers ON stg_orders.customer_id = stg_customers.customer_id
    LEFT JOIN stg_stores ON stg_orders.store_id = stg_stores.store_id
)

SELECT * FROM joined_tables