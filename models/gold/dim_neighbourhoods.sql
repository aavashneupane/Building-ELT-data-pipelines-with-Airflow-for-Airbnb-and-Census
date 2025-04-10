-- models/gold/dim_neighbourhoods.sql
{{ config(materialized='table') }}

SELECT DISTINCT
  "LISTING_NEIGHBOURHOOD" AS "NEIGHBOURHOOD_NAME",
  "LGA_NAME"
FROM {{ ref('silver_nsw_lga_code') }} 
JOIN {{ ref('silver_airbnb_listings') }}
ON {{ ref('silver_airbnb_listings') }}."LISTING_NEIGHBOURHOOD" = {{ ref('silver_nsw_lga_code') }}."LGA_NAME"
