WITH 

source AS ( 
    SELECT * FROM {{ source('ecom', 'raw_orders') }}
),

renamed AS (
    SELECT 
        ID AS ORDER_ID,
        CUSTOMER AS CUSTOMER_ID,
        ORDERED_AT AS ORDER_DATE,
        STORE_ID AS LOCATION_ID,
        SUBTOTAL AS PRETAX_PRICE,
        TAX_PAID AS TAX,
        ORDER_TOTAL AS TOTAL_PRICE
    FROM
        source
)

SELECT * FROM renamed

