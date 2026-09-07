/*
===========================================================
PROJECT : E-commerce Sales SQL Analysis
FILE    : 03_Customer_Analysis.sql
DATABASE: PostgreSQL

PURPOSE:
Analyze customer sales, order frequency, customer value,
customer segmentation, and repeat purchasing behavior.
===========================================================
*/


-- =========================================================
-- 1. TOP 10 CUSTOMERS BY SALES
-- =========================================================

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;


-- =========================================================
-- 2. AVERAGE ORDER VALUE OF TOP 10 CUSTOMERS
-- =========================================================

WITH top_customers AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID, Customer_Name
    ORDER BY Total_Sales DESC
    LIMIT 10
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(AVG(es.Sales), 2) AS Average_Order_Value
FROM ecommerce_sales AS es
JOIN top_customers AS tc
    ON es.Customer_ID = tc.Customer_ID
GROUP BY
    Customer_ID,
    Customer_Name
ORDER BY Average_Order_Value DESC;


-- =========================================================
-- 3. TOP 10 CUSTOMERS BY NUMBER OF ORDERS
-- =========================================================

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Orders DESC, Total_Sales DESC
LIMIT 10;


-- =========================================================
-- 4. OVERALL AVERAGE ORDER VALUE
-- =========================================================

SELECT
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales;


-- =========================================================
-- 5. CUSTOMER VALUE SEGMENTATION
-- =========================================================
-- Customers with total sales above the overall average
-- customer sales are classified as High Value.

WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID, Customer_Name
),
customer_average AS (
    SELECT
        AVG(Total_Sales) AS Average_Customer_Sales
    FROM customer_sales
)

SELECT
    CASE
        WHEN cs.Total_Sales >= ca.Average_Customer_Sales
            THEN 'High Value'
        ELSE 'Low Value'
    END AS Customer_Segment,
    COUNT(*) AS Total_Customers
FROM customer_sales AS cs
CROSS JOIN customer_average AS ca
GROUP BY Customer_Segment
ORDER BY Total_Customers DESC;


-- =========================================================
-- 6. SALES CONTRIBUTION BY CUSTOMER SEGMENT
-- =========================================================

WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID, Customer_Name
),
customer_average AS (
    SELECT
        AVG(Total_Sales) AS Average_Customer_Sales
    FROM customer_sales
),
customer_segments AS (
    SELECT
        cs.Customer_ID,
        cs.Customer_Name,
        cs.Total_Sales,
        CASE
            WHEN cs.Total_Sales >= ca.Average_Customer_Sales
                THEN 'High Value'
            ELSE 'Low Value'
        END AS Customer_Segment
    FROM customer_sales AS cs
    CROSS JOIN customer_average AS ca
)

SELECT
    Customer_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales,
    ROUND(
        SUM(Total_Sales) * 100.0 /
        (SELECT SUM(Total_Sales) FROM customer_sales),
        2
    ) AS Sales_Percentage
FROM customer_segments
GROUP BY Customer_Segment
ORDER BY Total_Sales DESC;


-- =========================================================
-- 7. REPEAT VS ONE-TIME CUSTOMERS
-- =========================================================
-- Repeat Customer = more than one order during the
-- analyzed period.
-- One-Time Customer = exactly one order.

WITH customer_orders AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Total_Orders
    FROM ecommerce_sales
    GROUP BY Customer_ID
)

SELECT
    CASE
        WHEN Total_Orders > 1
            THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS Customer_Type,
    COUNT(*) AS Total_Customers
FROM customer_orders
GROUP BY Customer_Type
ORDER BY Total_Customers DESC;


-- =========================================================
-- 8. CUSTOMER ORDER FREQUENCY
-- =========================================================

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Orders DESC, Total_Sales DESC;


/*
===========================================================
KEY INSIGHTS FROM CUSTOMER ANALYSIS

Top Customer by Sales:
- Kavya Malhotra
- Customer ID: CUST0248
- Total Orders: 17
- Total Sales: ₹1,408,933.35

Customer Segmentation:
- High Value Customers: 91
- Low Value Customers: 107

High Value Customer Contribution:
- High Value Customers generated approximately 70.37%
  of total sales.

Repeat Customer Analysis:
- Repeat Customers: 193
- One-Time Customers: 5

Repeat Customer Percentage:
- 97.47%

One-Time Customer Percentage:
- 2.53%

IMPORTANT:
"Repeat Customer" means the customer placed more than
one order during the analyzed dataset period. It does not
necessarily represent long-term customer retention.
===========================================================
*/