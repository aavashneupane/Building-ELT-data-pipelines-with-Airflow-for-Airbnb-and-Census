-- models/gold/dim_hosts.sql
{{ config(materialized='table') }}

SELECT DISTINCT
  "HOST_ID",
  "HOST_NAME",
  "HOST_IS_SUPERHOST",
  "HOST_SINCE",
  "HOST_NEIGHBOURHOOD"
FROM {{ ref('silver_airbnb_listings') }}
