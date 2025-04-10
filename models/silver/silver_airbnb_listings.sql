{{ config(materialized='view') }}

SELECT
  "LISTING_ID",
  "SCRAPE_ID",
  "SCRAPED_DATE"::DATE AS "SCRAPED_DATE",  -- Casting to date type
  "HOST_ID",
  "HOST_IS_SUPERHOST",
  "HOST_SINCE",
  "HOST_NEIGHBOURHOOD",
  "HAS_AVAILABILITY",
  "HOST_NAME",
  INITCAP("LISTING_NEIGHBOURHOOD") AS "LISTING_NEIGHBOURHOOD",  -- Formatting for consistency
  UPPER("PROPERTY_TYPE") AS "PROPERTY_TYPE",
  INITCAP("ROOM_TYPE") AS "ROOM_TYPE",
  "ACCOMMODATES",
  "AVAILABILITY_30",
  "REVIEW_SCORES_RATING",
  "PRICE"::NUMERIC AS "PRICE"  -- Ensuring price is numeric
FROM {{ ref('bronze_airbnb_listings') }}
