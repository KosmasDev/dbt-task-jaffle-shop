SELECT *
FROM {{ ref('orders') }}
WHERE ordered_at <= opening_date