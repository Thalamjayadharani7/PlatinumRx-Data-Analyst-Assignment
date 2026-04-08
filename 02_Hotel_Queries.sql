-- =========================================
-- HOTEL MANAGEMENT SYSTEM - QUERIES
-- =========================================

-- Q1: For every user, get the user_id and last booked room_no
SELECT user_id, room_no
FROM (
    SELECT 
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;

-- Q2: Get booking_id and total billing amount of every booking created in November 2021
SELECT 
    b.booking_id,
    ROUND(SUM(i.item_rate * bc.item_quantity), 2) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01'
  AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;

-- Q3: Get bill_id and bill amount of all bills raised in October 2021 having bill amount > 1000
SELECT 
    bc.bill_id,
    ROUND(SUM(i.item_rate * bc.item_quantity), 2) AS bill_amount
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
  AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(i.item_rate * bc.item_quantity) > 1000;

-- Q4: Determine the most ordered and least ordered item of each month of year 2021
WITH monthly_item_orders AS (
    SELECT 
        MONTH(bc.bill_date) AS month_no,
        i.item_id,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_id, i.item_name
),
ranked_items AS (
    SELECT *,
           RANK() OVER (PARTITION BY month_no ORDER BY total_qty DESC) AS most_rank,
           RANK() OVER (PARTITION BY month_no ORDER BY total_qty ASC) AS least_rank
    FROM monthly_item_orders
)
SELECT 
    month_no,
    item_id,
    item_name,
    total_qty,
    CASE 
        WHEN most_rank = 1 THEN 'Most Ordered'
        WHEN least_rank = 1 THEN 'Least Ordered'
    END AS order_type
FROM ranked_items
WHERE most_rank = 1 OR least_rank = 1
ORDER BY month_no, order_type;

-- Q5: Find customers with second highest bill value of each month of year 2021
WITH monthly_customer_bills AS (
    SELECT 
        MONTH(bc.bill_date) AS month_no,
        b.user_id,
        bc.bill_id,
        SUM(i.item_rate * bc.item_quantity) AS bill_value
    FROM booking_commercials bc
    JOIN bookings b 
        ON bc.booking_id = b.booking_id
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, bc.bill_id
),
ranked_bills AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month_no ORDER BY bill_value DESC) AS bill_rank
    FROM monthly_customer_bills
)
SELECT 
    month_no,
    user_id,
    bill_id,
    bill_value
FROM ranked_bills
WHERE bill_rank = 2
ORDER BY month_no;


output:

user_id	room_no
u1	rm102
u2	rm105
u3	rm104

booking_id	total_billing_amount
b3	538.00
b4	270.00

month_no	item_id	item_name	total_qty	order_type
9	i2	Mix Veg	1.00	Least Ordered
9	i1	Tawa Paratha	3.00	Most Ordered
10	i4	Rice	4.00	Least Ordered
10	i3	Paneer Curry	5.00	Most Ordered
11	i3	Paneer Curry	1.00	Least Ordered
11	i5	Soup	3.00	Most Ordered
12	i1	Tawa Paratha	10.00	Most Ordered

month_no	user_id	bill_id	bill_value
11	u3	bill4	270.0000
