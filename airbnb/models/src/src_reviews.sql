WITH raw_reviews AS (
    SELECT
        *
    FROM
        {{ source('airbnb', 'reviews') }}
        {# Can now be used instead of airbnb.raw.raw_reviews because of sources.yml #}
)
SELECT
    listing_id,
    date AS review_date,
    reviewer_name,
    comments AS review_text,
    sentiment AS review_sentiment
FROM
    raw_reviews
