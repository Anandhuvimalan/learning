--14
select * from(select f.title,cat.name,sum(p.amount)from category cat
JOIN film_category fc
on cat.category_id=fc.category_id
JOIN film f
ON fc.film_id=f.film_id
JOIN inventory i
on f.film_id=i.film_id
join rental r
ON i.inventory_id=r.inventory_id
join payment p
on r.rental_id=p.rental_id
group by f.title,cat.name) as tb
WHERE sum =(select MAX(sum) from (select f.title,cat.name,sum(p.amount)from category cat
JOIN film_category fc
on cat.category_id=fc.category_id
JOIN film f
ON fc.film_id=f.film_id
JOIN inventory i
on f.film_id=i.film_id
join rental r
ON i.inventory_id=r.inventory_id
join payment p
on r.rental_id=p.rental_id
group by f.title,cat.name) as tb1
where tb1.name=tb.name
);
--13
select f.title,p.payment_id,cat.name,p.amount,total_amount from category cat
JOIN film_category fc
on cat.category_id=fc.category_id AND cat.name='Action'
JOIN film f
ON fc.film_id=f.film_id
JOIN inventory i
on f.film_id=i.film_id
join rental r
ON i.inventory_id=r.inventory_id
join payment p
on r.rental_id=p.rental_id
join (
    select cat1.name, sum(p.amount) as total_amount from category cat1
    JOIN film_category fc
    on cat1.category_id=fc.category_id AND cat1.name='Action'
    JOIN film f
    ON fc.film_id=f.film_id
    JOIN inventory i
    on f.film_id=i.film_id
    join rental r
    ON i.inventory_id=r.inventory_id
    join payment p
    on r.rental_id=p.rental_id
    group by cat1.name
) as new
on cat.name = new.name
ORDER BY payment_id;
--12
select district,round(avg(sum),2) as average from (select first_name,last_name,district,sum(amount) from payment p
join customer c
on p.customer_id=c.customer_id
JOIN address ad
ON c.address_id=ad.address_id
group by first_name,last_name,district) cd
group by district
order by average DESC;
--11
select title,length,replacement_cost from film f1
where length > (select avg(length) from film f2
                where f2.replacement_cost=f1.replacement_cost)
order by length;

--10
select days,round(AVG(sum),2) from(select DATE(payment_date AT TIME ZONE 'Europe/Berlin') as date,EXTRACT('dow' from payment_date AT TIME ZONE 'Europe/Berlin') as days,sum(amount) from payment
group by date,days)
where days=0
group by days;

--9
select staff_id,round(AVG(sum),2) from (select staff_id,customer_id,round(SUM(amount),2) as sum from payment
group by staff_id,customer_id) as p
group by staff_id;


--8
select co.country,ci.city,sum(p.amount) from city ci
INNER JOIN address a
ON ci.city_id=a.city_id
INNER JOIN customer c
ON a.address_id=c.address_id
INNER JOIN payment p
ON c.customer_id=p.customer_id
INNER JOIN country co
ON ci.country_id=co.country_id
GROUP BY co.country,ci.city
ORDER BY SUM(p.amount)
LIMIT 1;
--7
select ci.city,sum(p.amount) from city ci
INNER JOIN address a
ON ci.city_id=a.city_id
INNER JOIN customer c
ON a.address_id=c.address_id
INNER JOIN payment p
ON c.customer_id=p.customer_id
GROUP BY ci.city
ORDER BY SUM(p.amount) DESC;
--6
select count(*) from address s
LEFT JOIN customer c
ON s.address_id=c.address_id
WHERE c.address_id is NULL;

--5
select a.first_name,a.last_name,count(*) from film f
LEFT JOIN film_actor fa
ON f.film_id=fa.film_id
LEFT JOIN actor a
ON fa.actor_id=a.actor_id
GROUP BY a.first_name,a.last_name
ORDER BY count(*) DESC
LIMIT 1;
--4
SELECT
    c.name,count(*)
FROM film f
LEFT OUTER JOIN film_category fc
ON f.film_id=fc.film_id
LEFT JOIN category c
ON fc.category_id=c.category_id
GROUP BY c.name
ORDER BY count(*) DESC
LIMIT 1;

--3
SELECT
    f.title,f.length,c.name
FROM film f
LEFT OUTER JOIN film_category fc
ON f.film_id=fc.film_id
LEFT JOIN category c
ON fc.category_id=c.category_id
WHERE c.name in('Sports','Drama')
ORDER BY f.length DESC;

select * from film
WHERE film_id in (select film_id from film_category
where category_id in (SELECT category_id from category
where name in ('Sports','Drama')))
ORDER BY length DESC;

--2
SELECT
    CASE
        WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
        WHEN replacement_cost BETWEEN 20 AND 24.99 THEN 'medium'
        WHEN replacement_cost BETWEEN 25 AND 29.99 THEN 'high'
    END as ret,
    count(*)
FROM
    film
WHERE replacement_cost BETWEEN 9.99 AND 19.99
group BY ret;

--1
SELECT
    MIN(replacement_cost)
FROM
    film;