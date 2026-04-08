-- =========================================
-- CLINIC MANAGEMENT SYSTEM - QUERIES
-- =========================================

-- Q1: Revenue by sales channel
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- Q2: Clinic-wise total revenue
SELECT 
    c.cid,
    c.clinic_name,
    SUM(cs.amount) AS total_revenue
FROM clinics c
JOIN clinic_sales cs 
    ON c.cid = cs.cid
GROUP BY c.cid, c.clinic_name
ORDER BY total_revenue DESC;

-- Q3: Monthly revenue, expenses, and profit/loss
WITH monthly_revenue AS (
    SELECT 
        MONTH(datetime) AS month_no,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
monthly_expenses AS (
    SELECT 
        MONTH(datetime) AS month_no,
        SUM(amount) AS total_expenses
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    r.month_no,
    r.total_revenue,
    e.total_expenses,
    (r.total_revenue - e.total_expenses) AS profit_loss
FROM monthly_revenue r
JOIN monthly_expenses e 
    ON r.month_no = e.month_no
ORDER BY r.month_no;

-- Q4: Top revenue-generating clinic for each month
WITH clinic_monthly_revenue AS (
    SELECT 
        MONTH(cs.datetime) AS month_no,
        c.cid,
        c.clinic_name,
        SUM(cs.amount) AS revenue
    FROM clinic_sales cs
    JOIN clinics c 
        ON cs.cid = c.cid
    WHERE YEAR(cs.datetime) = 2021
    GROUP BY MONTH(cs.datetime), c.cid, c.clinic_name
),
ranked_clinics AS (
    SELECT *,
           RANK() OVER (PARTITION BY month_no ORDER BY revenue DESC) AS revenue_rank
    FROM clinic_monthly_revenue
)
SELECT 
    month_no,
    cid,
    clinic_name,
    revenue
FROM ranked_clinics
WHERE revenue_rank = 1
ORDER BY month_no;

-- Q5: Customer with highest spending in each month
WITH customer_monthly_spend AS (
    SELECT 
        MONTH(cs.datetime) AS month_no,
        cu.uid,
        cu.name,
        SUM(cs.amount) AS total_spent
    FROM clinic_sales cs
    JOIN customer cu 
        ON cs.uid = cu.uid
    WHERE YEAR(cs.datetime) = 2021
    GROUP BY MONTH(cs.datetime), cu.uid, cu.name
),
ranked_customers AS (
    SELECT *,
           RANK() OVER (PARTITION BY month_no ORDER BY total_spent DESC) AS spend_rank
    FROM customer_monthly_spend
)
SELECT 
    month_no,
    uid,
    name,
    total_spent
FROM ranked_customers
WHERE spend_rank = 1
ORDER BY month_no;

output:
sales_channel	total_revenue
referral	9500.00
online	8000.00
offline	4500.00

cid	clinic_name	total_revenue
c3	Health Plus	8500.00
c4	Care Point	6000.00
c1	XYZ Clinic	5000.00
c2	ABC Clinic	2500.00

month_no	total_revenue	total_expenses	profit_loss
9	7500.00	2200.00	5300.00
10	6500.00	2800.00	3700.00
11	8000.00	1900.00	6100.00

month_no	cid	clinic_name	revenue
9	c1	XYZ Clinic	5000.00
10	c3	Health Plus	5000.00
11	c4	Care Point	4500.00

month_no	uid	name	total_spent
9	cu2	Sita	3000.00
10	cu1	Ravi	5000.00
11	cu3	Arjun	4500.00
