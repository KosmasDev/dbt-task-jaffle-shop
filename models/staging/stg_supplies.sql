with

source as (
    select * from {{ source('ecom', 'raw_supplies') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['id', 'sku']) }} as supply_uuid,
        id as supply_id,
        sku as product_id,
        name as supply_name,
        cost as supply_cost,
        perishable as is_perishable_supply
    from source
)

select * from renamed