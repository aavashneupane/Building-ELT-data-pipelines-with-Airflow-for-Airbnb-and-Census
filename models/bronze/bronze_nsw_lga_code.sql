SELECT
--   LISTING_ID,
--   NUMBER_OF_REVIEWS,
--   REVIEW_SCORES_RATING,
--   REVIEW_SCORES_ACCURACY,
--   REVIEW_SCORES_CLEANLINESS,
--   REVIEW_SCORES_CHECKIN,
--   REVIEW_SCORES_COMMUNICATION,
--   REVIEW_SCORES_VALUE
*
FROM {{ source('nsw', 'nsw_lga_code') }}