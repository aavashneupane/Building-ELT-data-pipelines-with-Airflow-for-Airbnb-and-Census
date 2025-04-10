-- models/gold/revenue_per_active_listing.sql
{{ config(materialized='view') }}

SELECT
  "LISTING_NEIGHBOURHOOD",
  SUM("ESTIMATED_REVENUE") / COUNT(*) FILTER (WHERE "HAS_AVAILABILITY" = 't') AS "REVENUE_PER_ACTIVE_LISTING"
FROM {{ ref('fact_listings_metrics') }}
WHERE "SCRAPED_DATE" BETWEEN '2020-03-01' AND '2021-03-31'
GROUP BY "LISTING_NEIGHBOURHOOD"
ORDER BY "REVENUE_PER_ACTIVE_LISTING" DESC
