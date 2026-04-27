SELECT CURRENT_ACCOUNT();

-- I have some issues getting this authenticated. I'll need to figure this out.

/*
So I have WD93490
AAKRBAA
and UC68357

*/

SELECT CONCAT_WS('.', CURRENT_ACCOUNT(), REPLACE(REGEXP_REPLACE(CURRENT_REGION(), '^[^_]+_',''), '_', '-')); -- e.g.: `YY00042.EU-CENTRAL-1`

-- drop view airbnb.dev_schema.src_listings

show columns in table airbnb.raw.raw_hosts;


-- INSERT INTO AIRBNB.RAW.RAW_REVIEWS VALUES (
-- 3176, CURRENT_TIMESTAMP(),'Zoltan', 'excellent stay!', 'positive');

select * from airbnb.raw.raw_reviews where listing_id = 3176 and reviewer_name = 'Zoltan';

select * from airbnb.dev.fct_reviews where listing_id = 3176 and reviewer_name = 'Zoltan';

DROP VIEW IF EXISTS AIRBNB.DEV.SRC_HOSTS;
DROP VIEW IF EXISTS AIRBNB.DEV.SRC_LISTINGS;
DROP VIEW IF EXISTS AIRBNB.DEV.SRC_REVIEWS;

UPDATE AIRBNB.RAW.RAW_LISTINGS SET MINIMUM_NIGHTS=30, UPDATED_AT = CURRENT_TIMESTAMP() WHERE ID=3176;

SELECT * FROM AIRBNB.DEV.SCD_RAW_LISTINGS WHERE ID=3176;

SELECT * FROM  AIRBNB.RAW.RAW_LISTINGS;

select * from airbnb.dev.fct_reviews;



select * from AIRBNB.DEV.FCT_REVIEWS;

select * from AIRBNB.DEV.DIM_LISTINGS_CLEANSED;

WITH fr AS (
    SELECT
        *
    FROM
        AIRBNB.DEV.FCT_REVIEWS
),
dlc AS (
    SELECT
        *
    FROM
        AIRBNB.DEV.DIM_LISTINGS_CLEANSED
)
SELECT
    *
FROM
    fr
    INNER JOIN dlc
    ON dlc.listing_id = fr.listing_id
WHERE
    fr.review_date < dlc.created_at;



SELECT 
    COUNT(*) AS cnt
FROM 
    AIRBNB.dev.dim_listings_cleansed
HAVING 
    COUNT(*) > 1000;


