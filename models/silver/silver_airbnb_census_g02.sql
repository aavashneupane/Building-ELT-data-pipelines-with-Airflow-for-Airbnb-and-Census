{{ config(materialized='view') }}

SELECT
  "LGA_CODE_2016",
  COALESCE("Median_age_persons", 0) AS "MEDIAN_AGE_PERSONS",  -- Renaming for clarity
  "Median_mortgage_repay_monthly",
  "Median_tot_prsnl_inc_weekly",
  "Median_rent_weekly",
  "Median_tot_fam_inc_weekly",
  ROUND("Average_num_psns_per_bedroom"::numeric, 2) AS "AVG_PERSONS_PER_BEDROOM",  -- Casting to numeric
  "Median_tot_hhd_inc_weekly",
  ROUND("Average_household_size"::numeric, 2) AS "AVG_HOUSEHOLD_SIZE"  -- Casting to numeric
FROM {{ ref('bronze_census_g02') }}
