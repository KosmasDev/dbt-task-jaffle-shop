WITH 

total_distinct_products AS (
  SELECT
    COUNT(DISTINCT(product_id))
  FROM
    {{ ref('stg_order_items') }}
),

customer_orders AS (
  SELECT
    ord.customer_id,
    COUNT(DISTINCT oi.product_id) AS count_product_id
  FROM
         {{ ref('stg_order_items') }} AS oi 
    JOIN {{ ref('stg_orders') }} AS ord ON ord.order_id = oi.order_id
    JOIN {{ ref('stg_customers') }} AS cust ON ord.customer_id = cust.customer_id
  GROUP BY
    ord.customer_id
),

customers_order_everything AS (
SELECT
  cust.customer_id,
  cust.customer_name,
  co.count_product_id
FROM
  customer_orders AS co
  JOIN {{ ref('stg_customers') }} AS cust ON co.customer_id = cust.customer_id
WHERE co.count_product_id = (SELECT * FROM total_distinct_products)
)

SELECT 
    CASE WHEN COUNT(*)>0 THEN 'YES' ELSE 'NO' END AS HAS_ANYONE_ORDER_EVERYTHING
FROM
    customers_order_everything