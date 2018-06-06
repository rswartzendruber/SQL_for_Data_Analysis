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

----JOIN Questions Part 1
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE a.name = 'Walmart';

SELECT r.name region_name, s.name rep_name , a.name account_name
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
ORDER BY a.name;

SELECT r.name region_name, a.name account_name, (o.total_amt_usd / (o.total + .01)) unit_price
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON o.account_id = a.id;

----Last Check
SELECT r.name region_name, s.name rep_name, a.name account_name
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

SELECT r.name region_name, s.name rep_name, a.name account_name
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
	AND s.name LIKE 'S%'
ORDER BY a.name;

SELECT r.name region_name, s.name rep_name, a.name account_name
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
	AND s.name LIKE '% K%'
ORDER BY a.name;

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON o.account_id = a.id
WHERE o.standard_qty > 100;

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

SELECT r.name region_name, a.name account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

SELECT DISTINCT a.name account_name, w.channel
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE a.id = '1001';

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01/01/2015' AND '12/31/2015'
ORDER BY o.occurred_at DESC;

--SQL Aggregations
----SUM
SELECT SUM(o.poster_qty) total_poster_qty
FROM orders o;
		--723646

SELECT SUM(o.standard_qty) total_standard_qty
FROM orders o;
		--1938346

SELECT SUM(o.total_amt_usd) total_sales_usd
FROM orders o;
		--23141511.83

SELECT o.id, o.standard_amt_usd + gloss_amt_usd std_and_gloss_usd
FROM orders o;

SELECT SUM(standard_amt_usd) / (SUM(standard_qty) + 0.001) avg_unit_price
FROM orders o;
		--4.9899999974256402

----MIN, MAX, & AVERAGE
SELECT MIN(o.occurred_at) earliest_order FROM orders o;
		--2013-12-04T04:22:44.000Z

SELECT o.occurred_at
FROM orders o
ORDER BY o.occurred_at
LIMIT 1;

SELECT MAX(w.occurred_at) newest_event
FROM web_events w;
		--2017-01-01T23:51:09.000Z

SELECT w.occurred_at
FROM web_events w
ORDER BY w.occurred_at DESC
LIMIT 1;

SELECT
	AVG(o.standard_qty)		avg_std_qty,
	AVG(o.standard_amt_usd) avg_std_usd,
	AVG(o.gloss_qty)		avg_gloss_qty,
	AVG(o.gloss_amt_usd)	avg_gloss_usd,
	AVG(o.poster_qty)		avg_poster_qty,
	AVG(o.poster_amt_usd)	avg_poster_usd
FROM orders o;

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;








