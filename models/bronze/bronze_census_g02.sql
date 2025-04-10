SELECT
 *
 FROM {{ source('census', 'census_g02_raw') }}