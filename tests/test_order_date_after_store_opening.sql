SELECT *
FROM {{ ref('orders') }}
WHERE order_date <= opening_date