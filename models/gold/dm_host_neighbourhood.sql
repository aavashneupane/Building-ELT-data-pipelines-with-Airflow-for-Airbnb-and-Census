-- models/datamart/dm_host_neighbourhood.sql
{{ config(materialized='view') }}

SELECT
  "LGA_NAME" AS "HOST_NEIGHBOURHOOD_LGA",
  DATE_TRUNC('month', "SCRAPED_DATE") AS "MONTH_YEAR",
  COUNT(DISTINCT {{ ref('fact_listings_metrics') }}."HOST_ID") AS "NUMBER_OF_DISTINCT_HOSTS",
  SUM("ESTIMATED_REVENUE") AS "ESTIMATED_REVENUE",
  SUM("ESTIMATED_REVENUE")::FLOAT / COUNT(DISTINCT {{ ref('fact_listings_metrics') }}."HOST_ID") AS "ESTIMATED_REVENUE_PER_HOST"
FROM {{ ref('fact_listings_metrics') }}
JOIN {{ ref('dim_hosts') }} ON {{ ref('fact_listings_metrics') }}."HOST_ID" = {{ ref('dim_hosts') }}."HOST_ID"
JOIN {{ ref('dim_neighbourhoods') }} ON {{ ref('dim_hosts') }}."HOST_NEIGHBOURHOOD" = {{ ref('dim_neighbourhoods') }}."NEIGHBOURHOOD_NAME"
GROUP BY "LGA_NAME", DATE_TRUNC('month', "SCRAPED_DATE")
ORDER BY "HOST_NEIGHBOURHOOD_LGA", "MONTH_YEAR"
