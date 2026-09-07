/*
===========================================================
PROJECT : E-commerce Sales SQL Analysis
FILE    : 05_Salesperson_Analysis.sql
DATABASE: PostgreSQL

PURPOSE:
Analyze salesperson performance based on sales,
profit, order volume, average order value,
profit margin, and overall ranking.
===========================================================
*/


-- =========================================================
-- 1. SALESPERSON PERFORMANCE SUMMARY
-- =========================================================

SELECT
    Salesperson,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC;


-- =========================================================
-- 2. SALESPERSON WITH HIGHEST SALES
-- =========================================================

SELECT
    Salesperson,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC
LIMIT 1;


-- =========================================================
-- 3. SALESPERSON WITH HIGHEST PROFIT
-- =========================================================

SELECT
    Salesperson,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Total_Profit DESC
LIMIT 1;


-- =========================================================
-- 4. SALESPERSON WHO HANDLED THE MOST ORDERS
-- =========================================================

SELECT
    Salesperson,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Total_Orders DESC
LIMIT 1;


-- =========================================================
-- 5. SALESPERSON WITH HIGHEST AVERAGE ORDER VALUE
-- =========================================================

SELECT
    Salesperson,
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Average_Order_Value DESC
LIMIT 1;


-- =========================================================
-- 6. SALESPERSON PROFIT MARGIN
-- =========================================================

SELECT
    Salesperson,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Profit_Margin_Percent DESC;


-- =========================================================
-- 7. SALESPERSON RANKING BY SALES
-- =========================================================

SELECT
    Salesperson,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank
FROM ecommerce_sales
GROUP BY Salesperson
ORDER BY Sales_Rank;


-- =========================================================
-- 8. COMPLETE SALESPERSON RANKING
-- =========================================================
-- Ranking is based on Total Sales.

WITH salesperson_summary AS (
    SELECT
        Salesperson,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        COUNT(DISTINCT Order_ID) AS Total_Orders,
        AVG(Sales) AS Average_Order_Value
    FROM ecommerce_sales
    GROUP BY Salesperson
)

SELECT
    Salesperson,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Total_Profit, 2) AS Total_Profit,
    Total_Orders,
    ROUND(Average_Order_Value, 2) AS Average_Order_Value,
    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank
FROM salesperson_summary
ORDER BY Sales_Rank;


/*
===========================================================
KEY INSIGHTS FROM SALESPERSON ANALYSIS

Highest Sales:
- Sonia
- Total Sales: ₹10,536,250.85

Highest Profit:
- Sonia
- Total Profit: ₹1,509,226.50

Most Orders:
- Sonia
- Total Orders: 119

Highest Average Order Value:
- Varun
- Average Order Value: ₹95,021.72

Sales Ranking:

1. Sonia
2. Aman
3. Yash
4. Pallavi
5. Mohit
6. Varun
7. Kavita
8. Raj
9. Tarun
10. Deepak


Highest Profit Margin:
- Deepak
- Profit Margin: 15.60%

===========================================================
*/