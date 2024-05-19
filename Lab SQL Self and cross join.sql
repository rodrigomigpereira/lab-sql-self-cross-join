## Lab | SQL Self and cross join.
## In this lab, you will be using the Sakila database of movie rentals.

use sakila; ## Use the database sakila 

## Instructions
## Get all pairs of actors that worked together.

select * from actor; ## columns --- actor_id, first_name, last_name, last_update
select * from film_actor; ## columns --- actor_id, film_id, last_update

SELECT DISTINCT a1.actor_id AS actor1_id, a1.first_name AS actor1_first_name, a1.last_name AS actor1_last_name,
                a2.actor_id AS actor2_id, a2.first_name AS actor2_first_name, a2.last_name AS actor2_last_name
FROM film_actor fa1
	JOIN film_actor fa2 
    ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
		JOIN actor a1 
        ON fa1.actor_id = a1.actor_id
			JOIN actor a2 
            ON fa2.actor_id = a2.actor_id
				ORDER BY a1.actor_id, a2.actor_id;

## Get all pairs of customers that have rented the same film more than 3 times.

select * from actor; ## columns --- actor_id, first_name, last_name, last_update
select * from film_actor; ## columns --- actor_id, film_id, last_update
select * from rental; ## columns --- rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update

WITH rental_counts AS (
    SELECT r1.customer_id AS customer1_id, r2.customer_id AS customer2_id, r1.inventory_id
		FROM rental r1
			JOIN rental r2 
            ON r1.inventory_id = r2.inventory_id AND r1.customer_id <> r2.customer_id
				GROUP BY r1.customer_id, r2.customer_id, r1.inventory_id
					HAVING COUNT(*) > 3
)
SELECT DISTINCT c1.customer_id AS customer1_id, c1.first_name AS customer1_first_name, c1.last_name AS customer1_last_name,
                c2.customer_id AS customer2_id, c2.first_name AS customer2_first_name, c2.last_name AS customer2_last_name
	FROM rental_counts rc
		JOIN customer c1 
		ON rc.customer1_id = c1.customer_id
			JOIN customer c2 
            ON rc.customer2_id = c2.customer_id
				ORDER BY customer1_id, customer2_id;

## Get all possible pairs of actors and films.

select * from actor; ## columns --- actor_id, first_name, last_name, last_update
select * from film; ## columns --- film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update

SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
	FROM actor a
		CROSS JOIN film f  ## CROSS JOIN keyword returns all records from both tables (table1 and table2) whether the other table matches or not. https://www.w3schools.com/mysql/mysql_join_cross.asp
			ORDER BY a.actor_id, f.film_id;