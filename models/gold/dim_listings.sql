-- models/gold/dim_listings.sql
{{ config(materialized='table') }}

SELECT DISTINCT
  "LISTING_ID",
  "LISTING_NEIGHBOURHOOD",
  "PROPERTY_TYPE",
  "ROOM_TYPE",
  "ACCOMMODATES"
FROM {{ ref('silver_airbnb_listings') }}
