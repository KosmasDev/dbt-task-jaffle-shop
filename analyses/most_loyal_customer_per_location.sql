WITH 

loyal_customers AS (
    SELECT
        customer_id,  
        customer_name, 
        location_id, 
        location_name,
        COUNT(*) AS visitis_to_the_store
    FROM
        {{ ref('orders') }}
    GROUP BY customer_id, customer_name, location_id, location_name
    ORDER BY COUNT(*) desc 
),

loyal_customers_ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY location_id ORDER BY visitis_to_the_store desc) AS ranking
    FROM loyal_customers
)
    
SELECT 
    customer_id, 
    customer_name,
    location_name,
    visitis_to_the_store 
FROM loyal_customers_ranked
WHERE ranking = 1