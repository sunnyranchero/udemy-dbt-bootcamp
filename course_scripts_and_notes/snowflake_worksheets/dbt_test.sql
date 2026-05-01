
    SELECT
        price,
        REGEXP_INSTR(
            price,
            '^\$[0-9]+\.[0-9]{2}$', 1, 1, 0, ''
        ) > 0 AS expression
    FROM
        airbnb.raw.raw_listings
