/*
===========================================================
PROJECT : E-commerce Sales SQL Analysis
FILE    : 04_Product_Analysis.sql
DATABASE: PostgreSQL

PURPOSE:
Analyze product-level sales, profit, quantity,
average order value, profit margins, and
category-wise product performance.
===========================================================
*/


-- =========================================================
-- 1. TOP 10 PRODUCTS BY SALES
-- =========================================================

SELECT
    Product,
    Category,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales
GROUP BY Product, Category
ORDER BY Total_Sales DESC
LIMIT 10;


-- =========================================================
-- 2. TOP 10 PRODUCTS BY PROFIT
-- =========================================================

SELECT
    Product,
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 / SUM(Sales),
        2
    ) AS Profit_Margin_Percent
FROM ecommerce_sales
GROUP BY Product, Category
ORDER BY Total_Profit DESC
LIMIT 10;


-- =========================================================
-- 3. PRODUCT-WISE PROFIT MARGIN
-- =========================================================

SELECT
    Product,
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM ecommerce_sales
GROUP BY Product, Category
ORDER BY Profit_Margin_Percent DESC;


-- =========================================================
-- 4. CATEGORY-WISE TOP 5 PRODUCTS BY SALES
-- =========================================================

WITH product_sales AS (
    SELECT
        Category,
        Product,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Category, Product
),
ranked_products AS (
    SELECT
        Category,
        Product,
        Total_Sales,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Sales DESC
        ) AS Product_Rank
    FROM product_sales
)

SELECT
    Category,
    Product,
    ROUND(Total_Sales, 2) AS Total_Sales,
    Product_Rank
FROM ranked_products
WHERE Product_Rank <= 5
ORDER BY Category, Product_Rank;


-- =========================================================
-- 5. CATEGORY-WISE TOP 5 PRODUCTS BY PROFIT
-- =========================================================

WITH product_profit AS (
    SELECT
        Category,
        Product,
        SUM(Profit) AS Total_Profit
    FROM ecommerce_sales
    GROUP BY Category, Product
),
ranked_products AS (
    SELECT
        Category,
        Product,
        Total_Profit,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Profit DESC
        ) AS Product_Rank
    FROM product_profit
)

SELECT
    Category,
    Product,
    ROUND(Total_Profit, 2) AS Total_Profit,
    Product_Rank
FROM ranked_products
WHERE Product_Rank <= 5
ORDER BY Category, Product_Rank;


-- =========================================================
-- 6. PRODUCT-WISE QUANTITY SOLD
-- =========================================================

SELECT
    Product,
    Category,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Product, Category
ORDER BY Total_Quantity_Sold DESC;


-- =========================================================
-- 7. TOP 10 PRODUCTS BY AVERAGE ORDER VALUE
-- =========================================================

SELECT
    Product,
    Category,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales
GROUP BY Product, Category
ORDER BY Average_Order_Value DESC
LIMIT 10;


/* 
===========================================================
KEY INSIGHTS FROM PRODUCT ANALYSIS

Top Products by Sales:

1. Laptop Pro 14
   Sales: ₹15,377,923.05

2. LED TV 55
   Sales: ₹12,517,317.35

3. Air Conditioner
   Sales: ₹8,606,771.15

4. Smartphone X
   Sales: ₹8,552,908.05

5. Tablet Plus
   Sales: ₹6,594,484.00


Top Product by Sales:
- Laptop Pro 14

Top Product by Quantity:
- Product-level quantity analysis is provided
  in Query 6.

Category-wise Product Ranking:
- Products are ranked within each category using
  the RANK() window function.

Profit Margin:
- Product-level profit margins are calculated as:
  Total Profit / Total Sales × 100

===========================================================
*/