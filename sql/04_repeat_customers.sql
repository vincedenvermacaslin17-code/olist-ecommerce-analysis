-- Q4: Repeat Customer Revenue Share
-- Dataset: Brazilian E-Commerce (Olist)

WITH customer_orders AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT orders.order_id) AS order_count,
        ROUND(SUM(price) + SUM(freight_value), 2) AS revenue
    FROM customers
    JOIN orders ON customers.customer_id = orders.customer_id
    JOIN order_items ON orders.order_id = order_items.order_id
	WHERE order_status = 'delivered'
    GROUP BY customer_unique_id
)
SELECT
CASE 
	WHEN order_count = 1 THEN 'one-time_customer' 
	ELSE 'repeat_customer' 
END AS customer_type,    
ROUND(SUM(revenue), 2) AS revenue
FROM customer_orders
GROUP BY customer_type;

-- total revenue (all delivered orders): 15,419,773.75 BRL
SELECT ROUND(SUM(price) + SUM(freight_value), 2) AS total_revenue
FROM order_items
JOIN orders ON orders.order_id = order_items.order_id
WHERE order_status = 'delivered'
;

-- percentages (calculated manually):
-- repeat:   (864187.46  / 15,419,773.75) * 100 = 5.60%
-- one-time: (14555586.29 / 15,419,773.75) * 100 = 94.40%


