{# that checks that there is no review date that is submitted before its listing was created: #}
{# Make sure that every review_date #}
{# IN fct_reviews IS more recent than THE associated created_at IN dim_listings_cleansed.#}
{# Testing where the created date is larger than the review date #}

SELECT
    fr.listing_id,
    fr.review_text,
    fr.review_date,
    dlc.created_at
FROM
    {{ ref('fct_reviews') }} fr
INNER JOIN {{ ref('dim_listings_cleansed') }} dlc
    ON dlc.listing_id = fr.listing_id
WHERE
    dlc.created_at > fr.review_date
