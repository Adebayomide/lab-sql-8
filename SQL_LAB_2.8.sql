-- Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, concat('$', SUM(p.amount)) as total_sales
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- Which film categories are longest?

SELECT c.name AS category, AVG(f.length) AS average_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY average_length DESC
limit 1;


-- Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC;


-- List the top five genres in gross revenue in descending order.

select c.name as genre, concat('$',sum(p.amount)) as gross_revenue
from category c
join film_category fc on c.category_id=fc.category_id
join inventory i on i.film_id=fc.film_id
join rental r on i.inventory_id=r.inventory_id
join payment p on p.rental_id=r.rental_id
group by genre
order by gross_revenue desc limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?


select f.title, count(f.film_id) as number_available,i.store_id  
from film f join inventory i 
on f.film_id=i.film_id
where title = 'Academy Dinosaur' and store_id=1
group by f.title;
#Yes it is available 



-- Get all pairs of actors that worked together.

SELECT CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM film_actor fa1
INNER JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
INNER JOIN actor a1 ON fa1.actor_id = a1.actor_id
INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id;



-- Bonus:
-- These questions are tricky, you can wait until after Monday's lesson to use new techniques to answer them!



-- Get all pairs of customers that have rented the same film more than 3 times.
#elect concat(c.first_name,' ',c.last_name),customer_id,f.title;


-- For each film, list actor that has acted in more films.

SELECT f.title, CONCAT(a.first_name, ' ', a.last_name) AS actor, COUNT(*) AS films_acted_in
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, actor
HAVING COUNT(*) = (
  SELECT MAX(films_acted_in)
  FROM (
    SELECT f2.film_id, COUNT(*) AS films_acted_in
    FROM film f2
    INNER JOIN film_actor fa2 ON f2.film_id = fa2.film_id
    GROUP BY f2.film_id, fa2.actor_id
  ) AS film_actor_counts
  WHERE film_actor_counts.film_id = f.film_id
)
ORDER BY films_acted_in desc;



