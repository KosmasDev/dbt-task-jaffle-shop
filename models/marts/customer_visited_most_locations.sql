-- Join orders with customer and location data
WITH 
joined_tables AS (
    SELECT 
        ord.order_id,
        ord.order_date,
        ord.customer_id,
        cust.customer_name,
        ord.location_id,
        loc.location_name,
        loc.opening_date
    FROM {{ ref('stg_orders') }} AS ord
    LEFT JOIN {{ ref('stg_customers') }} AS cust ON ord.customer_id = cust.customer_id
    LEFT JOIN {{ ref('stg_locations') }} AS loc ON ord.location_id = loc.location_id
),

-- Count how many different locations each customer has visited
customer_different_locations AS (
    SELECT 
        customer_id,
        customer_name, 
        COUNT(DISTINCT(location_id)) AS count_of_locations_visited 
    FROM joined_tables
    GROUP BY customer_id, customer_name
),

-- Rank customers based on the number of different locations they visited
customers_ranked AS (
    SELECT 
        *, 
        RANK() OVER (ORDER BY count_of_locations_visited DESC) AS ranking
    FROM customer_different_locations
)

-- Return the customer(s) who visited the most locations
SELECT 
    customer_id, 
    customer_name, 
    count_of_locations_visited
FROM customers_ranked
WHERE ranking = 1