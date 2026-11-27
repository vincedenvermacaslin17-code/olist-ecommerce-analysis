-- Session 15 — S10Q5: Product Category Profitability vs. Complaint Rate
-- Dataset: Brazilian E-Commerce (Olist)
-- Date: 2026-05-31

SELECT
	COUNT(DISTINCT orders.order_id) AS order_count,
    product_category_name,
    ROUND(SUM(price) + SUM(freight_value), 2) AS revenue,
    ROUND(COUNT(DISTINCT CASE WHEN review_score <= 2 THEN order_reviews.review_id END) / COUNT(DISTINCT order_reviews.review_id) * 100, 2) AS complaint_rate
FROM order_items
JOIN products ON order_items.product_id = products.product_id
JOIN order_reviews ON order_items.order_id = order_reviews.order_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.order_status = "delivered"
GROUP BY product_category_name
HAVING order_count >= 30
ORDER BY complaint_rate DESC;

-- correlation between revenue and complaint_rate = -0.044 (Excel CORR function)
-- near-zero: no meaningful linear relationship between revenue and complaint rate
