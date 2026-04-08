-- ============================================================
-- PlatinumRx Assignment | Hotel Management System
-- File: 02_Hotel_Queries.sql
-- Purpose: Solutions for Part A – Questions 1 through 5
-- ============================================================

-- ============================================================
-- Q1. For every user in the system, get user_id and
--     the room_no of their LAST booking.
-- ============================================================
-- Approach: Join users → bookings, group by user, take MAX(booking_date).
-- We then use that max date to retrieve the corresponding room_no.
-- A subquery / CTE + ROW_NUMBER() handles ties cleanly.

WITH ranked_bookings AS (
    SELECT
        b.user_id,
        b.room_no,
        b.booking_date,
        ROW_NUMBER() OVER (
            PARTITION BY b.user_id
            ORDER BY b.booking_date DESC   -- latest booking first
        ) AS rn
    FROM bookings b
)
SELECT
    u.user_id,
    u.name,
    rb.room_no          AS last_booked_room,
    rb.booking_date     AS last_booking_date
FROM users u
LEFT JOIN ranked_bookings rb
       ON u.user_id = rb.user_id
      AND rb.rn = 1
ORDER BY u.user_id;

-- ============================================================
-- Q2. Get booking_id and total billing amount of every
--     booking created in November 2021.
-- ============================================================
-- Approach: Join bookings → booking_commercials → items.
-- Total bill = SUM(item_quantity * item_rate) per booking.
-- Filter on booking_date falling within Nov 2021.

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items               i  ON bc.item_id   = i.item_id
WHERE b.booking_date >= '2021-11-01'
  AND b.booking_date <  '2021-12-01'      -- clean range avoids time-part issues
GROUP BY b.booking_id
ORDER BY total_billing_amount DESC;

-- ============================================================
-- Q3. Get bill_id and bill amount of all bills raised in
--     October 2021 having bill amount > 1000.
-- ============================================================
-- Approach: Group by bill_id (within booking_commercials),
-- SUM(quantity * rate), filter month + HAVING > 1000.

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
  AND bc.bill_date <  '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000
ORDER BY bill_amount DESC;

-- ============================================================
-- Q4. Determine the MOST and LEAST ordered item of each
--     month in year 2021.
-- ============================================================
-- "Most/Least ordered" = highest / lowest total quantity sold
-- across all bills in that month.
-- Strategy: aggregate quantity by month + item, then use
-- RANK() to label top (rank=1 ASC) and bottom (rank=1 DESC).

WITH monthly_item_totals AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m')  AS month,   -- e.g. '2021-09'
        i.item_id,
        i.item_name,
        SUM(bc.item_quantity)               AS total_qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), i.item_id, i.item_name
),
ranked AS (
    SELECT
        month,
        item_id,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rank_most,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC)  AS rank_least
    FROM monthly_item_totals
)
SELECT
    month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_most  = 1 THEN total_qty  END) AS most_ordered_qty,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN total_qty  END) AS least_ordered_qty
FROM ranked
WHERE rank_most = 1 OR rank_least = 1
GROUP BY month
ORDER BY month;

-- ============================================================
-- Q5. Find the customers with the SECOND HIGHEST bill value
--     of each month in year 2021.
-- ============================================================
-- Approach: Calculate total bill per customer per month,
-- rank using DENSE_RANK() (so ties still count as one rank),
-- then filter rank = 2.

WITH customer_monthly_bills AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m')  AS month,
        b.user_id,
        u.name,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN users    u ON b.user_id     = u.user_id
    JOIN items    i ON bc.item_id    = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), b.user_id, u.name, bc.bill_id
),
ranked_bills AS (
    SELECT
        month,
        user_id,
        name,
        bill_id,
        bill_amount,
        DENSE_RANK() OVER (
            PARTITION BY month
            ORDER BY bill_amount DESC
        ) AS bill_rank
    FROM customer_monthly_bills
)
SELECT
    month,
    user_id,
    name            AS customer_name,
    bill_id,
    bill_amount     AS second_highest_bill_amount
FROM ranked_bills
WHERE bill_rank = 2
ORDER BY month;
