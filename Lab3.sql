-- Q1
-- The average film length is 115.272 minutes.

SELECT title, length, rating
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
)
ORDER BY length DESC;


-- Q2
-- First, I calculated the total amount paid by each customer.
-- I then took the average of those totals.

SELECT AVG(customer_spending.total_spent) AS avg_customer_spend
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_spending;


-- Q3
/*
Both the four-table JOIN query and the subquery returned
63 rows for customer 130.

For this question, I find the JOIN version easier to follow
because I can see how each table connects to the next.
It also makes it clear where the film title and rental date
come from.

I would use the JOIN version for a more detailed rental report
that includes customer names and store IDs alongside the film
titles and rental dates.
*/

SELECT f.title, r.rental_date
FROM film AS f
CROSS JOIN rental AS r
WHERE r.customer_id = 130
  AND f.film_id IN (
      SELECT i.film_id
      FROM inventory AS i
      WHERE i.inventory_id = r.inventory_id
  )
ORDER BY r.rental_date ASC;


-- Q4
-- The CTE counts the rentals for each film.
-- The main query adds the titles and keeps films rented
-- more than 30 times.

WITH film_rental_counts AS (
    SELECT i.film_id, COUNT(*) AS rental_count
    FROM inventory AS i
    JOIN rental AS r
        ON i.inventory_id = r.inventory_id
    GROUP BY i.film_id
)
SELECT f.title, frc.rental_count
FROM film_rental_counts AS frc
JOIN film AS f
    ON frc.film_id = f.film_id
WHERE frc.rental_count > 30
ORDER BY frc.rental_count DESC;


-- Q5
-- I calculated each customer's total spending, then found
-- the average of those totals. The final query shows customers
-- who spent more than that average, with the highest spenders first.

WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
),
avg_spend AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM customer_totals
)
SELECT ct.customer_id, ct.total_spent, av.avg_spent
FROM customer_totals AS ct
CROSS JOIN avg_spend AS av
WHERE ct.total_spent > av.avg_spent
ORDER BY ct.total_spent DESC;


-- Q6
-- Query A: UNION ALL
/*
This query returned 1199 rows. It brings together all the names
from the actor and customer tables and keeps any duplicates.
This means 1199 is the number of combined records, not
necessarily the number of different people.
*/

SELECT first_name, last_name
FROM actor

UNION ALL

SELECT first_name, last_name
FROM customer;


-- Query B: INTERSECT
/*
The query found 1 shared name, meaning one first name and
last name combination appears in both tables.

If the query returned no rows, it would mean that none of the
full names matched. Even when a name matches, it does not
necessarily mean the records belong to the same person.
*/

SELECT first_name, last_name
FROM actor

INTERSECT

SELECT first_name, last_name
FROM customer;


-- Query C: EXCEPT
/*
This query shows actor names that are not listed in the
customer table. A name is only removed when both the first
and last names match a customer record. Each remaining name
appears once, sorted alphabetically by last name.
*/

SELECT first_name, last_name
FROM actor

EXCEPT

SELECT first_name, last_name
FROM customer

ORDER BY last_name ASC, first_name ASC;


-- Q7
/*
The error is in the above_average CTE, where AVG(total_spent)
is used directly in the WHERE clause.

As we covered in Module 2, WHERE filters rows before aggregate
functions are calculated at the same query level, so the
average is not available for that comparison.
I fixed this by adding a CTE to calculate the average first,
then using CROSS JOIN to make it available when filtering
the customer totals.
*/

WITH spending AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
),
avg_spend AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM spending
),
above_average AS (
    SELECT s.customer_id, s.total_spent
    FROM spending AS s
    CROSS JOIN avg_spend AS av
    WHERE s.total_spent > av.avg_spent
)
SELECT c.first_name, c.last_name, aa.total_spent
FROM customer AS c
JOIN above_average AS aa
    ON c.customer_id = aa.customer_id
ORDER BY aa.total_spent DESC;