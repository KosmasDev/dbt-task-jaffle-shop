with

source AS (
    SELECT * FROM {{ source('ecom', 'raw_stores') }}
),

renamed AS (
    SELECT
        id AS location_id,
        name AS location_name,
        tax_rate,
        opened_at AS opening_date
    FROM source
)

SELECT * FROM renamed