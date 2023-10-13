-- 1. Retrieve a lit of all users who have made at least 1 order

select
	username
from
	ecomm.users u
where
	user_id in (
	select
		distinct(user_id)
	from
		ecomm.orders)
order by
	username ;
	
-- 2. Calculate total revenue generated by the e-commerce website

select round(sum(total_amount)::numeric,2) total_revenue from ecomm.orders;

-- 3. Find the user who has placed the most orders

SELECT u.username,
	no_of_orders
FROM (
	SELECT *,
		rank() OVER (
			ORDER BY no_of_orders DESC
			)
	FROM (
		SELECT user_id,
			count(1) AS no_of_orders
		FROM ecomm.orders o
		GROUP BY user_id
		ORDER BY count(1) DESC
		) t1
	) t2
JOIN ecomm.users u ON t2.user_id = u.user_id
WHERE rank = 1;

-- 4. Identify the top-selling (top 5) product category

SELECT category,
	sum(quantity_sold) quantity_sold
FROM (
	SELECT *,
		rank() OVER (
			ORDER BY quantity_sold DESC
			) AS ranking
	FROM (
		SELECT od.product_id,
			sum(od.quantity) AS quantity_sold
		FROM ecomm.orders o
		RIGHT JOIN ecomm.orderdetails od ON o.order_id = od.order_id
		GROUP BY product_id
		ORDER BY quantity_sold
		) t3
	) t4
JOIN ecomm.products p ON t4.product_id = p.product_id
WHERE ranking <= 5
GROUP BY category;

--5. List the 5 most recent orders, including user's name and email

SELECT u.username,
	u.email,
	order_date
FROM (
	SELECT user_id,
		order_date,
		rank() OVER (
			ORDER BY order_date DESC
			) AS ranking
	FROM ecomm.orders o
	) t5
JOIN ecomm.users u ON t5.user_id = u.user_id
WHERE t5.ranking <= 5;

-- 6. Calcate the average order total for each product category

SELECT p.category,
	avg(o.total_amount) AS avg_order_amount
FROM ecomm.orders o
RIGHT JOIN ecomm.orderdetails od ON o.order_id = od.order_id
JOIN ecomm.products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_order_amount;

-- 7. Determine the user with the highest lifetime spending.

WITH t6
AS (
	SELECT u.username,
		sum(o.total_amount) AS total_spending
	FROM ecomm.orders o
	JOIN ecomm.users u ON o.user_id = u.user_id
	GROUP BY u.username
	)
SELECT username,
	round(total_spending::NUMERIC, 2) AS total_spending
FROM (
	SELECT *,
		rank() OVER (
			ORDER BY total_spending DESC
			)
	FROM t6
	) t7
WHERE rank = 1;

-- 8. Find the products that have never been ordered.
-- -----------------------------------
-- Insert a new product into the products table which 
-- will have not be present or used in orders table

INSERT INTO ecomm.products (
	product_id,
	product_name,
	category,
	price
	)
VALUES (
	555,
	'Test Product',
	'Test Category',
	0
	);


SELECT *
FROM ecomm.products p2
WHERE product_id NOT IN (
		SELECT od.product_id
		FROM ecomm.orders o
		JOIN ecomm.orderdetails od ON o.order_id = od.order_id
		JOIN ecomm.products p ON od.product_id = p.product_id
		);

-- 9. Calculate the total quantity of each product sold.

SELECT p.product_name,
	sum(od.quantity)
FROM ecomm.orders o
JOIN ecomm.orderdetails od ON o.order_id = od.order_id
JOIN ecomm.products p ON od.product_id = p.product_id
GROUP BY p.product_name;

-- 10. List the users who registered more than a year ago and have not placed any orders.
SELECT u.username,
	u.registration_date
FROM ecomm.orders o
FULL OUTER JOIN ecomm.users u ON o.user_id = u.user_id
WHERE o.order_id IS NULL
	AND u.registration_date < now() - interval '1 year';

-- 11. Rank Users by Total Spending: Rank users based on their total spending in descending order.

WITH t8
AS (
	SELECT *,
		rank() OVER (
			ORDER BY total_spending DESC
			)
	FROM (
		SELECT user_id,
			sum(total_amount) AS total_spending
		FROM ecomm.orders o
		GROUP BY user_id
		) t9
	)
SELECT u.username,
	round(total_spending::NUMERIC, 2) AS total_spending
FROM t8
JOIN ecomm.users u ON t8.user_id = u.user_id
WHERE rank <= 5;

-- 12. Calculate User Order Frequency: Find the average time between orders for each user.

WITH order_diff
AS (
	SELECT user_id,
		order_date - lag(order_date) OVER (
			PARTITION BY user_id ORDER BY order_date
			) AS difference
	FROM ecomm.orders
	)
SELECT u.username,
	avg(difference) AS avg_order_frequency
FROM order_diff od
JOIN ecomm.users u ON od.user_id = u.user_id
WHERE difference IS NOT NULL
GROUP BY u.username
ORDER BY avg_order_frequency;