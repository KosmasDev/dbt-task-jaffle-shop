WITH 

distinct_product_id AS (
  SELECT
    DISTINCT product_id
  FROM
    {{ ref('stg_order_items') }}
),

customer_orders AS (
  SELECT
    o.customer_id,
    COUNT(DISTINCT oi.product_id) AS product_id_count
  FROM
         {{ ref('stg_orders') }} AS o
    JOIN {{ ref('stg_order_items') }} AS oi ON o.order_id = oi.order_id
  GROUP BY
    o.customer_id
),

total_product_id AS (
  SELECT
    COUNT(*) AS product_id
  FROM
    distinct_product_id
),

customers_order_everything AS (
SELECT
  c.customer_id,
  c.customer_name,
  co.product_id_count
FROM
  customer_orders AS co
  JOIN {{ ref('stg_customers') }} AS c ON co.customer_id = c.customer_id
WHERE co.product_id_count = (SELECT * FROM total_product_id)
)

SELECT 
    CASE WHEN COUNT(*)>0 THEN 'YES' ELSE 'NO' END AS HAS_ANYONE_ORDER_EVERYTHING
FROM
    customers_order_everything