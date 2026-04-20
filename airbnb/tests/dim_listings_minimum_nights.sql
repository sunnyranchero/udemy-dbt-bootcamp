{# This is simply a custom sql thatwhen fails, returns the any non zero result, passes returns 0 results #}
{# Also called Singular tests. #}

SELECT
    *
FROM
    {{ ref('dim_listings_cleansed') }}
WHERE
    minimum_nights < 1
LIMIT
    10 
    
    {# The limit will keep this performant, if there is even 1 record, it should fail #}
    {# Any more just means that it REALLY failed. But is unnecessary. #}
