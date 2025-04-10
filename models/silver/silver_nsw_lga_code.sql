-- models/silver/silver_nsw_lga_code.sql

{{ config(materialized='view') }}

SELECT
  "LGA_CODE" as LGA_CODE,
  INITCAP("LGA_NAME") AS "LGA_NAME"
FROM {{ ref('bronze_nsw_lga_code') }}