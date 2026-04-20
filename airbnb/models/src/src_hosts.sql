WITH raw_hosts AS (
    SELECT
        *
    FROM
        {{ source('airbnb', 'listings') }}
        {# Can now be used instead of airbnb.raw.raw_hosts because of sources.yml #}
)
SELECT
    id AS host_id,
    name AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
