WITH raw_listings AS (
    SELECT
        *
    FROM
        {{ source('airbnb', 'listings') }}
        {# Can now be used instead of airbnb.raw.raw_listings because of sources.yml #}
)
SELECT
    id AS listing_id,
    name AS listing_name,
    listing_url,
    room_type,
    minimum_nights,
    host_id,
    price AS price_str,
    created_at,
    updated_at
FROM
    raw_listings
