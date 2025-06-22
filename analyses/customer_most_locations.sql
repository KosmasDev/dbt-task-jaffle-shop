WITH 

customer_different_locations AS (
    SELECT 
        customer_id,
        customer_name, 
        COUNT(DISTINCT(location_id)) AS count_of_different_locations 
    FROM {{ ref('orders') }}
    GROUP BY customer_id, customer_name
),

customers_ranked AS (
    SELECT 
        *, 
        RANK() OVER (ORDER BY count_of_different_locations DESC) AS ranking
    FROM customer_different_locations
)

SELECT 
    customer_id, 
    customer_name, 
    count_of_different_locations
FROM customers_ranked
WHERE ranking = 1