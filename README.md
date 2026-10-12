# Pagila Lab 3: Subqueries, CTEs, and Set Operations

Academic SQL work by Timer Senarith for ALY6420 at Northeastern University. This project uses the Pagila DVD rental database to examine film lengths, rental activity, customer spending, and overlapping name records.

## Tools

PostgreSQL 16, Neon, and DBeaver.

## SQL file

[View Lab3.sql](Lab3.sql)

Portfolio numbering follows the three included SQL projects. This assignment is labelled Lab 4 in the course; the repository file is named Lab3.sql.

## Objective

Break analytical questions into clear SQL steps and compare different ways to retrieve and summarize related records.

## Tasks

- Use a scalar subquery to identify films longer than the overall average.
- Calculate average customer spending from customer payment totals using a derived table.
- Rewrite customer 130’s rental query using an IN subquery and compare it with the JOIN approach.
- Use a film_rental_counts CTE to identify films rented more than 30 times.
- Combine customer_totals and avg_spend CTEs with CROSS JOIN to identify above-average spenders.
- Use UNION ALL to combine actor and customer names while retaining duplicates.
- Use INTERSECT to identify shared full-name combinations.
- Use EXCEPT to identify actor names absent from the customer table.
- Correct an aggregate expression incorrectly used in WHERE by separating the calculation into three CTEs.

## Confirmed database results

These checks were confirmed in the database instance used for the coursework.

| Check | Result |
|---|---:|
| Average film length | 115.272 minutes |
| Customer 130 rental query using JOINs | 63 rows |
| Customer 130 rental query using a subquery | 63 rows |
| Actor and customer names combined with UNION ALL | 1,199 rows |
| Shared full-name combinations returned by INTERSECT | 1 distinct combination |

Pagila versions and database modifications can change these values.

Matching row counts alone do not prove that two queries return identical records. Matching names also do not prove that records represent the same person.

## Analytical reasoning

Customer spending is first calculated at the customer level, then averaged across those totals. Because the calculation starts from payment records, it includes customers with payments rather than automatically treating customers without payments as zero spenders.

CTEs separate intermediate calculations from the final comparison. CROSS JOIN makes the single calculated average available alongside each customer total.

The set-operation examples distinguish between retaining every input row with UNION ALL and comparing distinct name combinations with INTERSECT and EXCEPT.

## Running the queries

1. Obtain the Pagila sample database distribution.
2. Create a PostgreSQL database locally or in Neon.
3. Load the schema first and the sample data second. Use psql for scripts that depend on its commands.
4. Connect through DBeaver and open Lab3.sql.
5. Execute individual questions and inspect their results.

For CTE queries, select the complete statement from WITH through the final SELECT.

The database itself is not included in this repository.

## Skills demonstrated

Scalar and correlated subqueries, derived tables, aggregation, CTEs, CROSS JOIN, set operations, result interpretation, and query debugging.

## Author

Timer Senarith
