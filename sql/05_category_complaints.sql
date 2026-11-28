-- Q5: Product Category Profitability vs. Complaint Rate
-- Dataset: Brazilian E-Commerce (Olist)

WITH product_category_revenue AS(
SELECT
	product_category_name,
	COUNT(DISTINCT orders.order_id) AS order_count,
    ROUND(SUM(price) + SUM(freight_value), 2) AS revenue
FROM order_items
JOIN products ON order_items.product_id = products.product_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.order_status = "delivered"
GROUP BY product_category_name
),
complaint_rates AS(
SELECT
	product_category_name,
	COUNT(DISTINCT orders.order_id) AS order_count,
    ROUND(COUNT(DISTINCT CASE WHEN review_score <= 2 THEN order_reviews.review_id END) / COUNT(DISTINCT order_reviews.review_id) * 100, 2) AS complaint_rate
FROM order_items
JOIN products ON order_items.product_id = products.product_id
JOIN order_reviews ON order_items.order_id = order_reviews.order_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.order_status = "delivered"
GROUP BY product_category_name
)
SELECT 
	pcr.product_category_name,
	pcr.order_count,
    pcr.revenue,
    crs.complaint_rate
FROM product_category_revenue AS pcr
LEFT JOIN complaint_rates AS crs ON pcr.product_category_name = crs.product_category_name
WHERE pcr.order_count >= 30 AND pcr.product_category_name IS NOT NULL
ORDER BY complaint_rate DESC
;


