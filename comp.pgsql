-- subquerries (in select , from and where)
select title from film
where film_id in (select film_id from inventory
where store_id=2
group by film_id
having count(*)>3 );

select * from payment
where amount > (select AVG(amount) from payment);

-- multiple joins
select c.first_name,c.last_name,c.email,co.country from customer c
INNER JOIN address a
ON c.address_id=a.address_id
INNER JOIN city ci
ON a.city_id=ci.city_id
INNER JOIN country co
ON ci.country_id=co.country_id
AND co.country='Brazil';

-- joins
select a.address,a.phone,a.district from address a
LEFT JOIN customer c
ON a.address_id=c.address_id
where c.address_id is NULL;

select c.first_name,c.last_name,a.phone,a.district from address a
INNER JOIN customer c
ON a.address_id=c.address_id
AND a.district='Texas';

-- replace
SELECT REPLACE('flight_delayed', '_', ' ') AS result;

-- CASTING
SELECT CAST('123' AS INTEGER);
-- or
SELECT '123'::INTEGER;


-- COALESCE
SELECT COALESCE(NULL, NULL, 'default') AS result;
-- Output: 'default'

-- EXTRACT
SELECT
    EXTRACT(month FROM (payment_date at TIME ZONE 'Europe/Berlin')) AS month, sum(amount)
FROM
    payment
GROUP BY EXTRACT(month FROM (payment_date at TIME ZONE 'Europe/Berlin'))
ORDER BY sum(amount) DESC;


-- substring
SELECT
    LEFT(email,1) || '***' || SUBSTRING(email,position('.' in email),2) || '***' || substring(email,position('@'in email))
FROM
    customer;

-- POSITION , SPLIT_PART
select CONCAT_WS(',',last_name,split_part(email,'.',1)) from customer;
select CONCAT_WS(',',last_name,LEFT(email,position('.' in email)-1)) from customer;



-- CONCAT_WS, CONCAT , ||
/*
-- || -> this give null when one column value is NULL
-- concat -> CONCAT(col1,' ',col2) nulls are skipped but we should have to mention space white space everytime
-- CONCAT_WS -> CONCAT_WS(' ',col1,col2,col3) best 
*/

SELECT CONCAT_WS('.',LEFT(first_name,1),LEFT(last_name,1)) from customer;


--lower()
select LEFT(RIGHT(email,4),1) from customer;

select lower(first_name),lower(last_name) from customer
where length(first_name)>10 or length(last_name)>10;
-- GROUP BY
select customer_id,DATE(payment_date AT TIME ZONE 'Europe/Berlin'),AVG(amount),COUNT(*) from payment
where DATE(payment_date AT TIME ZONE 'Europe/Berlin') in ('2020-04-28','2020-04-29','2020-04-30')
group by customer_id,DATE(payment_date AT TIME ZONE 'Europe/Berlin')
HAVING count(*) > 1
ORDER BY avg(amount) DESC ;


select staff_id,count(*) from payment
where amount<>0
group by staff_id,DATE(payment_date at time zone 'Europe/Berlin')
ORDER BY count(*) DESC;


SELECT
    SUM(amount)
FROM payment
group by customer_id
ORDER BY sum(amount) DESC;

-- aggregrate FUNCTION
SELECT
    SUM(replacement_cost),
    ROUND(AVG(replacement_cost),2),
    MAX(replacement_cost),
    MIN(replacement_cost) 
FROM
    film;
--LIKE
SELECT count(*) from customer
where first_name ~ '^.{3}$'
AND last_name ~ '.*[XY]$';
SELECT
    count(*)
FROM
    film
WHERE
    description ~ '.*Documentary.*';

-- BETWEEN

SELECT
    count(*)
FROM
    payment
WHERE
    (payment_date AT TIME ZONE 'Europe/Berlin' BETWEEN '2020-01-26 00:00:00' AND '2020-01-27 23:59:59')
    AND
    (amount BETWEEN 1.99 AND 3.99);

SELECT * from rental
where rental_date AT TIME ZONE 'Europe/Berlin' between '2005-05-24' AND '2005-05-26';

SELECT 
    payment_date,
    payment_date AT TIME ZONE 'Europe/Berlin' AS berlin_time
FROM payment
limit 1;

-- WHERE
SELECT
    last_name
FROM
    customer
WHERE
    first_name ~ 'ERICA';  -- case sensitive , can use like or first_name = 'ERICA'

SELECT 
    count(*)
FROM
    payment
WHERE
    customer_id=100;

-- LIMIT
SELECT
    customer_id,COUNT(*)
FROM
    payment
GROUP BY
    customer_id
ORDER BY
    COUNT(*) DESC
LIMIT 1 OFFSET 4;
--count -> true unique count
SELECT 
    amount
FROM
    payment
GROUP BY
    amount
HAVING count(*) =1;
-- select distinct (also keep null)
SELECT 
    DISTINCT store_id,active
FROM
    customer;
-- order by COLUMNS
SELECT  
    first_name
FROM    
    customer
ORDER BY 
    first_name DESC,last_name; -- default ASC


-- display the table
SELECT
    *
FROM
    customer;