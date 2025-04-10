SELECT
  *
FROM {{ source('airbnb', 'airbnb_raw') }}
