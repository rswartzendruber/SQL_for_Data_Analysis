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

----GROUP BY
SELECT a.name, o.occurred_at 
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) total_sales
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

SELECT a.name, w.occurred_at, w.channel
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

SELECT w.channel, COUNT(w.id) times_used
FROM web_events w
GROUP BY w.channel
ORDER BY times_used;

SELECT a.primary_poc
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

SELECT a.name, MIN(o.total_amt_usd) smallest_order_amt
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order_amt;

SELECT r.name, COUNT(s.id) rep_count
FROM region r
JOIN sales_reps s
	ON r.id = s.region_id
GROUP BY r.name
ORDER BY rep_count;

----GROUP BY Part 2
SELECT 
	a.name, 
	AVG(o.standard_qty) 	avg_std_qty,
	AVG(o.gloss_qty)			avg_gloss_qty,
	AVG(o.poster_qty)		avg_poster_qty
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

SELECT 
	a.name, 
	AVG(o.standard_amt_usd) 	avg_std_usd,
	AVG(o.gloss_amt_usd)		avg_gloss_usd,
	AVG(o.poster_amt_usd)		avg_poster_usd
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

SELECT s.name, w.channel, COUNT(w.id) times_used
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
JOIN sales_reps s
	ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY times_used DESC;

SELECT r.name, w.channel, COUNT(w.id) times_used
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
JOIN sales_reps s
	ON a.sales_rep_id = s.id
JOIN region r
	ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY times_used DESC;

----DISTINCT
SELECT DISTINCT a.name account_name, r.name region_name
FROM accounts a
JOIN sales_reps s
	ON a.sales_rep_id = s.id
JOIN region r
	ON s.region_id = r.id
ORDER BY a.name, r.name;

SELECT DISTINCT s.id, s.name
FROM sales_reps s;

SELECT s.id, s.name rep_name, COUNT(a.id) account_count
FROM sales_reps s
JOIN accounts a
	ON a.sales_rep_id = s.id
GROUP BY s.id, rep_name
ORDER BY account_count;

----HAVING
SELECT s.id, s.name rep_name, COUNT(a.id) account_count
FROM sales_reps s
JOIN accounts a
	ON a.sales_rep_id = s.id
GROUP BY s.id, rep_name
HAVING COUNT(a.id) > 5
ORDER BY account_count;
		--34

SELECT a.id, a.name account_name, COUNT(o.id) order_count
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, account_name
HAVING COUNT(o.id) > 20
ORDER BY a.name;
		--120

SELECT a.id, a.name account_name, COUNT(o.id) order_count
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, account_name
ORDER BY order_count DESC
LIMIT 1;
		--Leucadia National

SELECT a.id, a.name account_name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, account_name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent DESC;
		--204

SELECT a.id, a.name account_name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, account_name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent DESC;
		--3

SELECT a.id, a.name account_name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, account_name
ORDER BY total_spent DESC
LIMIT 1;
		--EOG Resources

SELECT a.id, a.name account_name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY a.id, account_name
ORDER BY total_spent
LIMIT 1;
		--Nike

SELECT a.name account_name, w.channel, COUNT(w.id) times_used
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY account_name, w.channel
HAVING COUNT(w.id) > 6
ORDER BY times_used;
		--46

SELECT a.name account_name, w.channel, COUNT(w.id) times_used
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY account_name, w.channel
ORDER BY times_used DESC
LIMIT 1;
		--Gilead Sciences

SELECT a.name account_name, w.channel, COUNT(w.id) times_used
FROM accounts a
JOIN web_events w
	ON a.id = w.account_id
GROUP BY account_name, w.channel
ORDER BY times_used DESC
LIMIT 10;
		--direct

----DATE FUNCTIONS
SELECT DATE_PART('year', o.occurred_at) AS year, SUM(o.total_amt_usd) total_sales
FROM orders o
GROUP BY 1
ORDER BY 2 DESC;
		--2016

SELECT DATE_PART('month', o.occurred_at) AS month, SUM(o.total_amt_usd) total_sales
FROM orders o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY 1
ORDER BY 2 DESC;
		--12

SELECT DATE_PART('year', o.occurred_at) AS year, COUNT(o.id) order_qty
FROM orders o
GROUP BY 1
ORDER BY 2 DESC;
		--2016

SELECT DATE_PART('month', o.occurred_at) AS month, COUNT(o.id) order_qty
FROM orders o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY 1
ORDER BY 2 DESC;
		--2016-12-01

SELECT a.name, DATE_TRUNC('month', o.occurred_at) AS month, SUM(o.gloss_amt_usd) total_gloss_amt_usd
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;
		--2016-05-01

----CASE
SELECT 	a.name AS account_name,
		SUM(o.total_amt_usd) AS total_sales,
		CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
		 	 WHEN SUM(o.total_amt_usd) >= 100000 AND SUM(o.total_amt_usd) <= 200000  THEN 'between 100,000 and 200,000'
		 	 ELSE 'under 100,000' END AS level
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT 	a.name AS account_name,
		SUM(o.total_amt_usd) AS total_sales,
		CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
		 	 WHEN SUM(o.total_amt_usd) >= 100000 AND SUM(o.total_amt_usd) <= 200000  THEN 'between 100,000 and 200,000'
		 	 ELSE 'under 100,000' END AS level
FROM accounts a
JOIN orders o
	ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
GROUP BY 1
ORDER BY 2 DESC;

SELECT 	s.name AS rep_name,
		COUNT(o.id) AS order_qty,
		CASE WHEN COUNT(o.id) >200 THEN 'top'
			 ELSE 'not' END AS is_top
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT 	s.name AS rep_name,
		COUNT(o.id) AS order_qty,
		SUM(o.total_amt_usd) AS total_sales,
		CASE WHEN COUNT(o.id) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
			 WHEN COUNT(o.id) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
			 ELSE 'low' END AS rep_level
FROM sales_reps s
JOIN accounts a
	ON s.id = a.sales_rep_id
JOIN orders o
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;

--SQL Subqueries & Temporary Tables
----Write Your First Subquery
SELECT 	channel,
		AVG(event_count)
FROM (SELECT 	DATE_TRUNC('day', w.occurred_at) AS day,
		w.channel,
		COUNT(w.id) AS event_count
 	  FROM web_events w
 	  GROUP BY 1, 2) sub
GROUP BY 1
ORDER BY 2 DESC;

----More On Subqueries
SELECT  DATE_TRUNC('month', o.occurred_at) AS month, 
		AVG(o.standard_qty) AS avg_std_qty,
		AVG(o.gloss_qty) AS avg_gloss_qty,
		AVG(o.poster_qty) AS avg_poster_qty
FROM orders o
WHERE DATE_TRUNC('month', o.occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(o.occurred_at)) AS earliest_order_date
	 FROM orders o)
GROUP BY 1;

SELECT  DATE_TRUNC('month', o.occurred_at) AS month, 
		SUM(o.total_amt_usd) AS total_sales
FROM orders o
WHERE DATE_TRUNC('month', o.occurred_at) = 
	(SELECT DATE_TRUNC('month', MIN(o.occurred_at)) AS earliest_order_date
	 FROM orders o)
GROUP BY 1;

----Subquery Mania
SELECT t3.region_id, t3.region_name, t3.rep_id, t3.rep_name, t3.total_sales
FROM	(SELECT region_id, region_name, MAX(total_sales) AS max_sales
		FROM 	(SELECT r.id region_id, r.name region_name, s.id rep_id, s.name rep_name, SUM(o.total_amt_usd) AS total_sales
				FROM sales_reps s
				JOIN accounts a
					ON s.id = a.sales_rep_id
				JOIN orders o
					ON o.account_id = a.id
				JOIN region r
					ON r.id = s.region_id
				GROUP BY 1, 2, 3, 4) t1
		GROUP BY 1, 2) t2
JOIN 	(SELECT r.id region_id, r.name region_name, s.id rep_id, s.name rep_name, SUM(o.total_amt_usd) AS total_sales
		FROM sales_reps s
		JOIN accounts a
			ON s.id = a.sales_rep_id
		JOIN orders o
			ON o.account_id = a.id
		JOIN region r
			ON r.id = s.region_id
		GROUP BY 1, 2, 3, 4) t3
ON t2.region_id = t3.region_id
	AND t2.max_sales = t3.total_sales
ORDER BY 2,4;

SELECT t3.region_id, t3.region_name, t3.total_sales, t3.order_qty
FROM	(SELECT MAX(total_sales) AS max_sales
		FROM 	(SELECT r.id region_id, r.name region_name, SUM(o.total_amt_usd) AS total_sales
				FROM sales_reps s
				JOIN accounts a
					ON s.id = a.sales_rep_id
				JOIN orders o
					ON o.account_id = a.id
				JOIN region r
					ON r.id = s.region_id
				GROUP BY 1, 2) t1) t2
JOIN 	(SELECT r.id region_id, r.name region_name, SUM(o.total_amt_usd) AS total_sales, COUNT(o.id) AS order_qty
		FROM sales_reps s
		JOIN accounts a
			ON s.id = a.sales_rep_id
		JOIN orders o
			ON o.account_id = a.id
		JOIN region r
			ON r.id = s.region_id
		GROUP BY 1, 2) t3
	ON t2.max_sales = t3.total_sales;

SELECT COUNT(t2.id)
FROM 	(SELECT a.id, a.name
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		HAVING SUM(o.total) > (SELECT t1.tot_qty
								FROM 	(SELECT a.id, a.name, SUM(o.standard_qty) AS tot_std_qty, SUM(total) AS tot_qty
										FROM accounts a
										JOIN orders o
											ON a.id = o.account_id
										GROUP BY 1, 2
										ORDER BY 3 DESC
										LIMIT 1) t1)
		) t2;

SELECT t1.name, w.channel, COUNT(w.id) AS event_count
FROM 	(SELECT a.id AS id, a.name AS name, SUM(o.total_amt_usd) AS total_purchases
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 1) t1
JOIN web_events w
	ON t1.id = w.account_id
GROUP BY 1, 2
ORDER BY 2; 						

SELECT AVG(t1.total_purchases) AS avg_of_top_10_purchases
FROM 	(SELECT a.id AS id, a.name AS name, SUM(o.total_amt_usd) AS total_purchases
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 10) t1;

SELECT AVG(t1.total_purchases)
FROM 	(SELECT a.id AS account_id, a.name AS account_name, AVG(o.total_amt_usd) total_purchases
		FROM orders o
		JOIN accounts a
			ON o.account_id = a.id
		GROUP BY 1, 2
		HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) AS avg_order_amt
		FROM orders o)) t1;

--WITH
WITH t1 AS (
		SELECT r.id region_id, r.name region_name, s.id rep_id, s.name rep_name, SUM(o.total_amt_usd) AS total_sales
		FROM sales_reps s
		JOIN accounts a
			ON s.id = a.sales_rep_id
		JOIN orders o
			ON o.account_id = a.id
		JOIN region r
			ON r.id = s.region_id
		GROUP BY 1, 2, 3, 4),
	t2 AS (
		SELECT region_id, region_name, MAX(total_sales) AS max_sales
		FROM t1
		GROUP BY 1,2)

SELECT t1.region_id, t1.region_name, t1.rep_id, t1.rep_name, t1.total_sales
FROM t1
JOIN t2
	ON t1.total_sales = t2.max_sales


WITH t1 AS (
		SELECT r.id region_id, r.name region_name, SUM(o.total_amt_usd) AS total_sales, COUNT(o.id) AS order_qty
		FROM sales_reps s
		JOIN accounts a
			ON s.id = a.sales_rep_id
		JOIN orders o
			ON o.account_id = a.id
		JOIN region r
			ON r.id = s.region_id
		GROUP BY 1, 2),
	t2 	AS (
		SELECT MAX(total_sales) AS max_sales
		FROM t1)

SELECT t1.region_id, t1.region_name, t1.total_sales, t1.order_qty
FROM t2
JOIN t1
	ON t1.total_sales = t2.max_sales

WITH t1 AS (
		SELECT a.id, a.name, SUM(o.standard_qty) AS tot_std_qty, SUM(total) AS tot_qty
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 1),
	 t2 AS (
	 	SELECT a.id, a.name
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		HAVING SUM(o.total) > (SELECT t1.tot_qty FROM t1))

SELECT COUNT(t2.id)
FROM t2;

WITH t1 AS (
		SELECT a.id AS id, a.name AS name, SUM(o.total_amt_usd) AS total_purchases
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 1)

SELECT t1.name, w.channel, COUNT(w.id) AS event_count
FROM t1
JOIN web_events w
	ON t1.id = w.account_id
GROUP BY 1, 2
ORDER BY 2; 

WITH t1 AS (
		SELECT a.id AS id, a.name AS name, SUM(o.total_amt_usd) AS total_purchases
		FROM accounts a
		JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 10)

SELECT AVG(t1.total_purchases) AS avg_of_top_10_purchases
FROM t1;

WITH t1 AS (
		SELECT a.id AS account_id, a.name AS account_name, AVG(o.total_amt_usd) total_purchases
		FROM orders o
		JOIN accounts a
			ON o.account_id = a.id
		GROUP BY 1, 2
		HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) AS avg_order_amt
		FROM orders o))

SELECT AVG(t1.total_purchases)
FROM t1;

--SQL Data Cleaning
----LEFT & RIGHT
SELECT RIGHT(a.website, 3) AS root_domain, COUNT(a.id) AS site_count
FROM accounts a
GROUP BY 1
ORDER BY 2 DESC;

SELECT LEFT(a.name, 1) AS first_letter, COUNT(a.id) AS company_count
FROM accounts a
GROUP BY 1
ORDER BY 2 DESC;

WITH t1 AS (
		SELECT 	CASE WHEN LEFT(a.name, 1) NOT IN ('1','2','3','4','5','6','7','8','9','0') THEN 1 ELSE 0 END AS letters,
				CASE WHEN LEFT(a.name, 1) IN ('1','2','3','4','5','6','7','8','9','0') THEN 1 ELSE 0 END AS nums 
		FROM accounts a)

SELECT SUM(letters) AS letter_count, SUM(nums) AS num_count
FROM t1;

WITH t1 AS (
		SELECT 	CASE WHEN LEFT(LOWER(a.name), 1) IN ('a','e','i','o','u') THEN 1 ELSE 0 END AS vowels,
		 		CASE WHEN LEFT(LOWER(a.name), 1) NOT IN ('a','e','i','o','u') THEN 1 ELSE 0 END AS other
		FROM accounts a)

SELECT SUM(vowels) AS vowel_count, SUM(other) as other_count
FROM t1;

----POSITION and STRPOS

SELECT 	a.primary_poc,
		LEFT(a.primary_poc, POSITION(' ' IN a.primary_poc) - 1) AS first_name,
		RIGHT(a.primary_poc, LENGTH(a.primary_poc) - POSITION(' ' IN a.primary_poc)) AS last_name
FROM accounts a
ORDER BY 1;

SELECT 	s.name,
		LEFT(s.name, STRPOS(s.name, ' ') - 1) AS first_name,
		RIGHT(s.name, LENGTH(s.name) - STRPOS(s.name, ' ')) AS last_name
FROM sales_reps s
ORDER BY 1;

----CONCAT
SELECT a.name, a.primary_poc, 
	REPLACE(CONCAT(
		LEFT(a.primary_poc, POSITION(' ' IN a.primary_poc) - 1),
		'.',
		RIGHT(a.primary_poc, LENGTH(a.primary_poc) - POSITION(' ' IN a.primary_poc)),
		'@',
		a.name,
		'.com'), ' ', '') AS email_address
FROM accounts a
ORDER BY a.name

SELECT a.name, a.primary_poc, 
	CONCAT(
		LEFT(a.primary_poc, POSITION(' ' IN a.primary_poc) - 1),
		'.',
		RIGHT(a.primary_poc, LENGTH(a.primary_poc) - POSITION(' ' IN a.primary_poc)),
		'@',
		a.name,
		'.com') AS email_address
FROM accounts a
ORDER BY a.name

WITH t1 AS (
		SELECT 	a.name AS account_name,
				LEFT(a.primary_poc, POSITION(' ' IN a.primary_poc) - 1) AS poc_first_name,
				RIGHT(a.primary_poc, LENGTH(a.primary_poc) - POSITION(' ' IN a.primary_poc)) AS poc_last_name
		FROM accounts a)


SELECT t1.account_name, t1.poc_first_name, t1.poc_last_name,
	CONCAT(
		LOWER(LEFT(t1.poc_first_name, 1)),
		LOWER(RIGHT(t1.poc_first_name, 1)),
		LOWER(LEFT(t1.poc_last_name, 1 )),
		LOWER(RIGHT(t1.poc_last_name, 1)),
		LENGTH(t1.poc_first_name),
		LENGTH(t1.poc_last_name),
		UPPER(REPLACE(t1.account_name, ' ', ''))) AS password
FROM t1
ORDER BY t1.account_name

----CAST
SELECT CONCAT(
		SUBSTR(date, 7, 4),
		'-',
		SUBSTR(date, 1, 2),
		'-',
		SUBSTR(date, 4, 2))::date AS date
FROM sf_crime_data
LIMIT 10;

----COALESCE
SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long,
	 a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at,
	 o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, 
	 o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, 
	a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, 
	COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
	COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, 
	a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, 
	COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
	COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

--SQL Window Functions
----

