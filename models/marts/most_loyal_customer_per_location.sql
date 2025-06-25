-- Join order, customer, and location data into a single unified table
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

-- Count how many times each customer visited each store (location)
loyal_customers AS (
    SELECT
        customer_id,  
        customer_name, 
        location_id, 
        location_name,
        COUNT(*) AS store_visits
    FROM
        joined_tables
    GROUP BY customer_id, customer_name, location_id, location_name
    ORDER BY COUNT(*) DESC 
),

-- Rank customers per location based on how frequently they visited
loyal_customers_ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY location_id ORDER BY store_visits DESC) AS ranking
    FROM loyal_customers
)

-- Return the most loyal customer(s) per store (rank = 1)
SELECT 
    customer_id, 
    customer_name,
    location_name,
    store_visits 
FROM loyal_customers_ranked
WHERE ranking = 1