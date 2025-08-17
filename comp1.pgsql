SELECT
    actual_departure - scheduled_departure,
    CASE
        WHEN actual_departure is NULL THEN 'no departure time'
        WHEN (actual_departure - scheduled_departure) < interval '5 minutes' THEN 'on time'
        ELSE 'late'
    END AS departure_status
FROM
    flights;