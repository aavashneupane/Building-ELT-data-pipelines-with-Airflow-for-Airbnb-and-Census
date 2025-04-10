SELECT
 *
 FROM {{ source('census', 'census_g01_raw') }}