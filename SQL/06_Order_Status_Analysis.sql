/*
===========================================================
PROJECT : E-commerce Sales SQL Analysis
FILE    : 06_Order_Status_Analysis.sql
DATABASE: PostgreSQL

PURPOSE:
Analyze order performance by order status, including
order volume, sales, profit, percentage contribution,
and returned/cancelled orders.
===========================================================
*/


-- =========================================================
-- 1. ORDER STATUS DISTRIBUTION
-- =========================================================

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(
        COUNT(DISTINCT Order_ID) * 100.0 /
        (SELECT COUNT(DISTINCT Order_ID)
         FROM ecommerce_sales),
        2
    ) AS Order_Percentage
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Total_Orders DESC;


-- =========================================================
-- 2. SALES AND PROFIT BY ORDER STATUS
-- =========================================================

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Total_Sales DESC;


-- =========================================================
-- 3. AVERAGE ORDER VALUE BY ORDER STATUS
-- =========================================================

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Average_Order_Value DESC;


-- =========================================================
-- 4. PROFIT MARGIN BY ORDER STATUS
-- =========================================================

SELECT
    Order_Status,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Profit_Margin_Percent DESC;


-- =========================================================
-- 5. RETURNED AND CANCELLED ORDERS BY REGION
-- =========================================================

SELECT
    Region,
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
WHERE Order_Status IN ('Returned', 'Cancelled')
GROUP BY Region, Order_Status
ORDER BY Region, Total_Orders DESC;


-- =========================================================
-- 6. RETURNED + CANCELLED ORDERS BY REGION
-- =========================================================

SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Returned_Cancelled_Orders,
    ROUND(SUM(Sales), 2) AS Returned_Cancelled_Sales
FROM ecommerce_sales
WHERE Order_Status IN ('Returned', 'Cancelled')
GROUP BY Region
ORDER BY Returned_Cancelled_Orders DESC;


-- =========================================================
-- 7. RETURN AND CANCELLATION RATE BY REGION
-- =========================================================

WITH region_orders AS (
    SELECT
        Region,
        COUNT(DISTINCT Order_ID) AS Total_Orders
    FROM ecommerce_sales
    GROUP BY Region
),
problem_orders AS (
    SELECT
        Region,
        COUNT(DISTINCT Order_ID) AS Returned_Cancelled_Orders
    FROM ecommerce_sales
    WHERE Order_Status IN ('Returned', 'Cancelled')
    GROUP BY Region
)

SELECT
    ro.Region,
    ro.Total_Orders,
    COALESCE(po.Returned_Cancelled_Orders, 0)
        AS Returned_Cancelled_Orders,
    ROUND(
        COALESCE(po.Returned_Cancelled_Orders, 0) * 100.0 /
        ro.Total_Orders,
        2
    ) AS Return_Cancellation_Rate
FROM region_orders AS ro
LEFT JOIN problem_orders AS po
    ON ro.Region = po.Region
ORDER BY Return_Cancellation_Rate DESC;


/*
===========================================================
KEY INSIGHTS FROM ORDER STATUS ANALYSIS

Order Status Distribution:

Delivered:
- 694 orders
- 69.40%

Shipped:
- 111 orders
- 11.10%

Processing:
- 102 orders
- 10.20%

Returned:
- 50 orders
- 5.00%

Cancelled:
- 43 orders
- 4.30%


SALES BY STATUS:

Delivered:
- Sales: ₹55,205,080.15
- Profit: ₹7,726,152.39

Shipped:
- Sales: ₹9,617,193.70
- Profit: ₹1,339,472.94

Processing:
- Sales: ₹8,632,306.75
- Profit: ₹1,077,168.94

Returned:
- Sales: ₹4,082,172.95
- Profit: ₹568,256.43

Cancelled:
- Sales: ₹3,568,930.45
- Profit: ₹457,931.80


RETURNED + CANCELLED ORDERS BY REGION:

South:
- 23 orders
- 10.55% of total South orders

North:
- 30 orders
- 10.53% of total North orders

East:
- 18 orders
- 8.61% of total East orders

West:
- 22 orders
- 7.64% of total West orders


KEY OBSERVATIONS:

1. Delivered orders represent the majority of all orders
   at 69.40%.

2. South has the highest return/cancellation rate
   at 10.55%.

3. West has the lowest return/cancellation rate
   at 7.64%.

4. North has the highest number of returned/cancelled
   orders with 30 orders.

===========================================================
*/