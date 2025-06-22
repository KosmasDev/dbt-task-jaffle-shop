WITH 

stg_orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

stg_customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

stg_locations AS (
    SELECT * FROM {{ ref('stg_locations') }}
),

joined_tables AS (
    SELECT 
        stg_orders.order_id,
        stg_orders.order_date,
        stg_orders.customer_id,
        stg_customers.customer_name,
        stg_orders.location_id,
        stg_locations.location_name,
        stg_locations.opening_date
    FROM stg_orders
    LEFT JOIN stg_customers ON stg_orders.customer_id = stg_customers.customer_id
    LEFT JOIN stg_locations ON stg_orders.location_id = stg_locations.location_id
)

SELECT * FROM joined_tables