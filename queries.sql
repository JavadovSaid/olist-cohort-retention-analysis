-- =====================================================================
-- COHORT RETENTION ANALYSIS PIPELINE (PostgreSQL)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q1 to Q5: Main Cohort Retention Matrix Pipeline
-- ---------------------------------------------------------------------
WITH delivered_orders AS (
    -- Q1: Filter for delivered orders and join with customers to get customer_unique_id
    SELECT 
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    -- Q2: Determine cohort_month (first purchase month per customer_unique_id)
    SELECT 
        customer_unique_id,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM delivered_orders
    GROUP BY customer_unique_id
),

customer_activities AS (
    -- Q3: Extract all distinct order months per customer
    SELECT DISTINCT
        customer_unique_id,
        DATE_TRUNC('month', order_purchase_timestamp) AS activity_month
    FROM delivered_orders
),

period_calculation AS (
    -- Q4: Compute period_number (month difference between activity and cohort month)
    SELECT 
        a.customer_unique_id,
        c.cohort_month,
        a.activity_month,
        (EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month)) AS period_number
    FROM customer_activities a
    JOIN customer_cohorts c ON a.customer_unique_id = c.customer_unique_id
)

-- Q5: Customer Count Matrix per Cohort and Period Number
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    period_number,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM period_calculation
GROUP BY cohort_month, period_number
ORDER BY cohort_month, period_number;


-- ---------------------------------------------------------------------
-- Q6: Cohort Starting Sizes (Period 0 Count)
-- ---------------------------------------------------------------------
WITH delivered_orders AS (
    SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp
    FROM orders o 
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
customer_cohorts AS (
    SELECT 
        customer_unique_id,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM delivered_orders
    GROUP BY customer_unique_id
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    COUNT(DISTINCT customer_unique_id) AS cohort_size
FROM customer_cohorts
GROUP BY cohort_month
ORDER BY cohort_month;


-- ---------------------------------------------------------------------
-- Q7: Retention Rate Matrix (%)
-- ---------------------------------------------------------------------
WITH delivered_orders AS (
    SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp
    FROM orders o 
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
customer_cohorts AS (
    SELECT 
        customer_unique_id,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM delivered_orders
    GROUP BY customer_unique_id
),
customer_activities AS (
    SELECT DISTINCT
        customer_unique_id,
        DATE_TRUNC('month', order_purchase_timestamp) AS activity_month
    FROM delivered_orders
),
period_calc AS (
    SELECT 
        a.customer_unique_id,
        c.cohort_month,
        (EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month)) AS period_number
    FROM customer_activities a 
    JOIN customer_cohorts c ON a.customer_unique_id = c.customer_unique_id
),
cohort_sizes AS (
    SELECT 
        cohort_month, 
        COUNT(DISTINCT customer_unique_id) AS total_size
    FROM customer_cohorts 
    GROUP BY cohort_month
),
retention_counts AS (
    SELECT 
        cohort_month, 
        period_number, 
        COUNT(DISTINCT customer_unique_id) AS active_users
    FROM period_calc 
    GROUP BY cohort_month, period_number
)
SELECT 
    TO_CHAR(rc.cohort_month, 'YYYY-MM') AS cohort_month,
    rc.period_number,
    rc.active_users,
    cs.total_size AS cohort_size,
    ROUND((rc.active_users::NUMERIC / cs.total_size::NUMERIC) * 100, 2) AS retention_rate_pct
FROM retention_counts rc
JOIN cohort_sizes cs ON rc.cohort_month = cs.cohort_month
ORDER BY rc.cohort_month, rc.period_number;


-- ---------------------------------------------------------------------
-- Q8: Average Retention Rate per Period Number across All Cohorts
-- ---------------------------------------------------------------------
WITH delivered_orders AS (
    SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp
    FROM orders o JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
customer_cohorts AS (
    SELECT customer_unique_id, DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM delivered_orders GROUP BY customer_unique_id
),
customer_activities AS (
    SELECT DISTINCT customer_unique_id, DATE_TRUNC('month', order_purchase_timestamp) AS activity_month
    FROM delivered_orders
),
period_calc AS (
    SELECT 
        a.customer_unique_id,
        c.cohort_month,
        (EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month)) AS period_number
    FROM customer_activities a JOIN customer_cohorts c ON a.customer_unique_id = c.customer_unique_id
),
cohort_sizes AS (
    SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS total_size
    FROM customer_cohorts GROUP BY cohort_month
),
retention_rates AS (
    SELECT 
        p.cohort_month,
        p.period_number,
        (COUNT(DISTINCT p.customer_unique_id)::NUMERIC / cs.total_size::NUMERIC) * 100 AS retention_rate
    FROM period_calc p
    JOIN cohort_sizes cs ON p.cohort_month = cs.cohort_month
    GROUP BY p.cohort_month, p.period_number, cs.total_size
)
SELECT 
    period_number,
    ROUND(AVG(retention_rate), 2) AS avg_retention_pct
FROM retention_rates
GROUP BY period_number
ORDER BY period_number;


-- ---------------------------------------------------------------------
-- Q9: Best and Worst Performing Cohorts by Month-1 Retention Rate
-- ---------------------------------------------------------------------
WITH delivered_orders AS (
    SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp
    FROM orders o JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
customer_cohorts AS (
    SELECT customer_unique_id, DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM delivered_orders GROUP BY customer_unique_id
),
customer_activities AS (
    SELECT DISTINCT customer_unique_id, DATE_TRUNC('month', order_purchase_timestamp) AS activity_month
    FROM delivered_orders
),
period_calc AS (
    SELECT 
        a.customer_unique_id,
        c.cohort_month,
        (EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month)) AS period_number
    FROM customer_activities a JOIN customer_cohorts c ON a.customer_unique_id = c.customer_unique_id
),
cohort_sizes AS (
    SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS total_size
    FROM customer_cohorts GROUP BY cohort_month
),
month_1_retention AS (
    SELECT 
        p.cohort_month,
        COUNT(DISTINCT p.customer_unique_id) AS period_1_customers,
        cs.total_size AS total_cohort_size,
        ROUND((COUNT(DISTINCT p.customer_unique_id)::NUMERIC / cs.total_size::NUMERIC) * 100, 2) AS retention_rate_p1
    FROM period_calc p
    JOIN cohort_sizes cs ON p.cohort_month = cs.cohort_month
    WHERE p.period_number = 1
    GROUP BY p.cohort_month, cs.total_size
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    total_cohort_size,
    period_1_customers,
    retention_rate_p1
FROM month_1_retention
ORDER BY retention_rate_p1 DESC;


-- ---------------------------------------------------------------------
-- Q10: Revenue Retention per Cohort per Period
-- ---------------------------------------------------------------------
WITH delivered_orders AS (
    SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp
    FROM orders o JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
customer_cohorts AS (
    SELECT customer_unique_id, DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
    FROM delivered_orders GROUP BY customer_unique_id
),
order_revenues AS (
    SELECT 
        o.order_id,
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS activity_month,
        SUM(i.price) AS total_order_revenue
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items i ON o.order_id = i.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id, c.customer_unique_id, activity_month
)
SELECT 
    TO_CHAR(cc.cohort_month, 'YYYY-MM') AS cohort_month,
    (EXTRACT(YEAR FROM r.activity_month) - EXTRACT(YEAR FROM cc.cohort_month)) * 12 +
    (EXTRACT(MONTH FROM r.activity_month) - EXTRACT(MONTH FROM cc.cohort_month)) AS period_number,
    ROUND(SUM(r.total_order_revenue), 2) AS period_revenue
FROM order_revenues r
JOIN customer_cohorts cc ON r.customer_unique_id = cc.customer_unique_id
GROUP BY cohort_month, period_number
ORDER BY cohort_month, period_number;