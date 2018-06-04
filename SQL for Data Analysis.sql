--SQL for Data Analysis

----ORDER BY
SELECT id, occurred_at, total_amt_usd
FROM orders
Order By occurred_at 
LIMIT 10;

SELECT id, account_id, total_amt_usd
FROM orders
Order By total_amt_usd DESC
LIMIT 5;

SELECT id, account_id, total
FROM orders
Order By total
LIMIT 20;

----ORDER BY Part 2
SELECT id, occurred_at, account_id, total_amt_usd
FROM orders
Order By occurred_at DESC, total_amt_usd DESC
LIMIT 5;

SELECT id, occurred_at, account_id, total_amt_usd
FROM orders
ORDER BY occurred_at, total_amt_usd
LIMIT 10;

----WHERE
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

----WHERE with Non-Numeric Data
SELECT name, website, primary_poc
FROM accounts 
WHERE name = 'Exxon Mobil';

----Arithmetic Operators
/*
Derived columns are custom columns, not just selected from a table. Involve arithmetic operators or some other form of manipulation
*/
SELECT 
	id, 
	account_id,
	standard_amt_usd / standard_qty AS unit_price 
FROM orders
LIMIT 10;

SELECT 
	id,
	account_id,
	poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd + .0000001) AS poster_revenue_perc
FROM orders;

----LIKE
SELECT name
FROM accounts
WHERE name like 'C%';

SELECT name
FROM accounts
WHERE name like '%one%';

SELECT name
FROM accounts
WHERE name like '%s';

----IN
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

----NOT
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';

SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

----AND and BETWEEN
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '01/01/2016' AND '12/31/2016'
ORDER BY occurred_at DESC;

----OR
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0
	AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
	AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
	AND primary_poc NOT LIKE '%eana%';

--SQL JOINS
----Your First JOIN
SELECT *
FROM accounts
JOIN orders
	ON accounts.id = orders.account_id;

SELECT orders.standard_qty, orders.gloss_qty, 
	orders.poster_qty, accounts.website, accounts.primary_poc
FROM accounts
JOIN orders
	On accounts.id = orders.account_id;