{{ config(materialized='view') }}

SELECT
  INITCAP("LGA_NAME") AS "LGA_NAME",  -- Formatting for consistent casing
  INITCAP("SUBURB_NAME") AS "SUBURB_NAME"
FROM {{ ref('bronze_nsw_lga_suburb') }}
