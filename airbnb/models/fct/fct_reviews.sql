{{ config(
    materialized = 'incremental',
    on_schema_change = 'fail'
) }}
    {# this was created earlier to purposely fail if schema changed... section 10 #}

WITH src_reviews AS (

    SELECT
        *
    FROM
        {{ ref('src_reviews') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date', 'review_text']) }} as review_id,
    *
FROM
    src_reviews
WHERE
    review_text IS NOT NULL

{% if is_incremental() %}
AND review_date > (
    SELECT
        MAX(review_date)
    FROM
        {{ this }}
)
{% endif %}
