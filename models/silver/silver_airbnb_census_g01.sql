{{ config(materialized='view') }}

SELECT
  "LGA_CODE_2016",
  COALESCE("Tot_P_P", 0) AS "TOTAL_POPULATION",  -- Handling nulls with COALESCE
  COALESCE("Age_0_4_yr_P", 0) AS "AGE_0_4",
  COALESCE("Age_5_14_yr_P", 0) AS "AGE_5_14",
  COALESCE("Age_15_19_yr_P", 0) AS "AGE_15_19",
  COALESCE("Age_20_24_yr_P", 0) AS "AGE_20_24",
  COALESCE("Age_25_34_yr_P", 0) AS "AGE_25_34",
  COALESCE("Age_35_44_yr_P", 0) AS "AGE_35_44",
  COALESCE("Age_45_54_yr_P", 0) AS "AGE_45_54",
  COALESCE("Age_55_64_yr_P", 0) AS "AGE_55_64",
  COALESCE("Age_65_74_yr_P", 0) AS "AGE_65_74",
  COALESCE("Age_75_84_yr_P", 0) AS "AGE_75_84",
  COALESCE("Age_85ov_P", 0) AS "AGE_85_PLUS"
FROM {{ ref('bronze_census_g01') }}
