-- LEFT JOIN
SELECT
    RIGHT(s.seat_no,1),count(*)
FROM
    seats s
LEFT OUTER JOIN
    boarding_passes bp
ON s.seat_no = bp.seat_no
GROUP BY RIGHT(s.seat_no,1)
ORDER BY count(*) DESC;

-- OUTER JOIN
SELECT
    count(*)
FROM
    tickets t
FULL OUTER JOIN
    boarding_passes bp
    on t.ticket_no=bp.ticket_no
WHERE
    bp.ticket_no is NULL;
    
-- INNER JOIN
SELECT
    s.fare_conditions,count(*)
FROM
    boarding_passes bp
INNER JOIN
    seats s on bp.seat_no=s.seat_no
GROUP BY s.fare_conditions;