WITH bookings AS (
    SELECT * FROM {{ ref('stg_cal_bookings') }}
),
event_types AS (
    SELECT 
        id as event_type_id,
        title as event_name,
        price
    FROM {{ source('snowflake_raw', 'RAW_CAL_EVENT_TYPES') }}
),
users AS (
    SELECT 
        id as user_id,
        username as host_name,
        plan as host_plan
    FROM {{ source('snowflake_raw', 'RAW_CAL_USERS') }}
)

SELECT
    b.booking_id,
    b.booking_status,
    b.start_time,
    b.no_show_guest,
    b.day_of_week,
    e.event_name,
    e.price as potential_revenue,
    u.host_name,
    u.host_plan,
    -- Lógica Exclusiva: Se deu no-show e era pago = receita vazou!
    CASE 
        WHEN b.no_show_guest = TRUE AND e.price > 0 THEN e.price 
        ELSE 0 
    END as revenue_lost
FROM bookings b
LEFT JOIN event_types e ON b.event_type_id = e.event_type_id
LEFT JOIN users u ON b.user_id = u.user_id
