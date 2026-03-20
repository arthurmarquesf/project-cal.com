SELECT
    id as booking_id,
    uid as booking_uid,
    user_id,
    event_type_id,
    status as booking_status,
    start_time,
    no_show_guest,
    -- Métrica calculada no dbt
    DAYNAME(start_time) as day_of_week
FROM {{ source('snowflake_raw', 'RAW_CAL_BOOKINGS') }}
