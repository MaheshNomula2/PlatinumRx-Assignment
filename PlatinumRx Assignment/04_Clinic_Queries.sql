-- ============================================================
-- PlatinumRx Assignment | Clinic Management System
-- File: 04_Clinic_Queries.sql
-- Purpose: Solutions for Part B – Questions 1 through 5
-- Replace @target_year / @target_month with actual values
-- e.g. SET @target_year = 2021; SET @target_month = '2021-09';
-- ============================================================

SET @target_year  = 2021;          -- change as needed
SET @target_month = '2021-09';     -- change as needed (YYYY-MM)

-- ============================================================
-- Q1. Revenue from each sales channel for a given year.
-- ============================================================
SELECT
    sales_channel,
    SUM(amount)   AS total_revenue,
    COUNT(oid)    AS total_orders
FROM clinic_sales
WHERE YEAR(datetime) = @target_year
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- ============================================================
-- Q2. Top 10 most valuable customers for a given year.
-- ============================================================
-- "Valuable" = highest total spend (sum of sale amounts).

SELECT
    cs.uid,
    c.name,
    c.mobile,
    SUM(cs.amount)  AS total_spend,
    COUNT(cs.oid)   AS total_orders
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = @target_year
GROUP BY cs.uid, c.name, c.mobile
ORDER BY total_spend DESC
LIMIT 10;

-- ============================================================
-- Q3. Month-wise Revenue, Expense, Profit and Status
--     for a given year.
-- ============================================================
-- Strategy:
--   a) Aggregate revenue per month from clinic_sales.
--   b) Aggregate expenses per month from expenses.
--   c) LEFT JOIN both on month so months with no expense still appear.
--   d) Profit = Revenue - Expense; label as Profitable / Not-Profitable.

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount)                    AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @target_year
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
),
monthly_expenses AS (
    SELECT
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount)                    AS expense
    FROM expenses
    WHERE YEAR(datetime) = @target_year
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
)
SELECT
    mr.month,
    COALESCE(mr.revenue,  0)                      AS total_revenue,
    COALESCE(me.expense,  0)                      AS total_expense,
    COALESCE(mr.revenue,  0) - COALESCE(me.expense, 0) AS profit,
    CASE
        WHEN COALESCE(mr.revenue, 0) - COALESCE(me.expense, 0) >= 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM monthly_revenue mr
LEFT JOIN monthly_expenses me ON mr.month = me.month
ORDER BY mr.month;

-- ============================================================
-- Q4. For each city, find the MOST PROFITABLE clinic
--     for a given month.
-- ============================================================

WITH clinic_month_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        DATE_FORMAT(cs.datetime, '%Y-%m') AS month,
        COALESCE(SUM(cs.amount), 0)       AS revenue
    FROM clinics cl
    LEFT JOIN clinic_sales cs ON cl.cid = cs.cid
           AND DATE_FORMAT(cs.datetime, '%Y-%m') = @target_month
    GROUP BY cl.cid, cl.clinic_name, cl.city, DATE_FORMAT(cs.datetime, '%Y-%m')
),
clinic_month_expense AS (
    SELECT
        cid,
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        COALESCE(SUM(amount), 0)       AS expense
    FROM expenses
    WHERE DATE_FORMAT(datetime, '%Y-%m') = @target_month
    GROUP BY cid, DATE_FORMAT(datetime, '%Y-%m')
),
clinic_profit AS (
    SELECT
        cmp.city,
        cmp.cid,
        cmp.clinic_name,
        cmp.revenue - COALESCE(cme.expense, 0) AS profit
    FROM clinic_month_profit cmp
    LEFT JOIN clinic_month_expense cme ON cmp.cid = cme.cid
),
ranked AS (
    SELECT
        city,
        cid,
        clinic_name,
        profit,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, clinic_name, profit AS highest_profit
FROM ranked
WHERE rnk = 1
ORDER BY city;

-- ============================================================
-- Q5. For each state, find the SECOND LEAST PROFITABLE clinic
--     for a given month.
-- ============================================================

WITH clinic_month_rev AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.state,
        COALESCE(SUM(cs.amount), 0) AS revenue
    FROM clinics cl
    LEFT JOIN clinic_sales cs ON cl.cid = cs.cid
           AND DATE_FORMAT(cs.datetime, '%Y-%m') = @target_month
    GROUP BY cl.cid, cl.clinic_name, cl.state
),
clinic_month_exp AS (
    SELECT
        cid,
        COALESCE(SUM(amount), 0) AS expense
    FROM expenses
    WHERE DATE_FORMAT(datetime, '%Y-%m') = @target_month
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cr.state,
        cr.cid,
        cr.clinic_name,
        cr.revenue - COALESCE(ce.expense, 0) AS profit
    FROM clinic_month_rev cr
    LEFT JOIN clinic_month_exp ce ON cr.cid = ce.cid
),
ranked AS (
    SELECT
        state,
        cid,
        clinic_name,
        profit,
        -- Least profitable = lowest profit, so ASC; second least = rank 2
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, clinic_name, profit AS second_least_profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
