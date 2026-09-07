/*
===========================================================
PROJECT : E-commerce Sales SQL Analysis
FILE    : 02_Sales_Analysis.sql
DATABASE: PostgreSQL

PURPOSE:
Analyze overall sales, profit, order value,
regional performance, category performance,
and monthly sales trends.
===========================================================
*/


-- =========================================================
-- 1. OVERALL SALES, COST AND PROFIT
-- =========================================================

SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales;


-- =========================================================
-- 2. TOTAL ORDERS AND ITEMS SOLD
-- =========================================================

SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Items_Sold
FROM ecommerce_sales;


-- =========================================================
-- 3. AVERAGE ORDER VALUE (AOV)
-- =========================================================

SELECT
    ROUND(AVG(Sales), 2) AS Average_Order_Value
FROM ecommerce_sales;


-- =========================================================
-- 4. OVERALL PROFIT MARGIN
-- =========================================================

SELECT
    ROUND(
        SUM(Profit) * 100.0 / SUM(Sales),
        2
    ) AS Overall_Profit_Margin_Percent
FROM ecommerce_sales;


-- =========================================================
-- 5. REGION-WISE SALES
-- =========================================================

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Sales DESC;


-- =========================================================
-- 6. REGION-WISE SALES CONTRIBUTION
-- =========================================================

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(
        SUM(Sales) * 100.0 /
        (SELECT SUM(Sales) FROM ecommerce_sales),
        2
    ) AS Sales_Percentage
FROM ecommerce_sales
GROUP BY Region
ORDER BY Sales_Percentage DESC;


-- =========================================================
-- 7. CATEGORY-WISE SALES
-- =========================================================

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY Category
ORDER BY Total_Sales DESC;


-- =========================================================
-- 8. CATEGORY-WISE PROFIT
-- =========================================================

SELECT
    Category,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales
GROUP BY Category
ORDER BY Total_Profit DESC;


-- =========================================================
-- 9. CATEGORY-WISE PROFIT MARGIN
-- =========================================================

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 / SUM(Sales),
        2
    ) AS Profit_Margin_Percent
FROM ecommerce_sales
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;


-- =========================================================
-- 10. MONTH-WISE SALES
-- =========================================================

SELECT
    TO_CHAR(DATE_TRUNC('month', Order_Date), 'Month') AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM ecommerce_sales
GROUP BY DATE_TRUNC('month', Order_Date)
ORDER BY DATE_TRUNC('month', Order_Date);


-- =========================================================
-- 11. MONTH-OVER-MONTH SALES GROWTH
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', Order_Date) AS Month,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY DATE_TRUNC('month', Order_Date)
)

SELECT
    TO_CHAR(Month, 'Month') AS Month_Name,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(
        LAG(Total_Sales) OVER (ORDER BY Month),
        2
    ) AS Previous_Month_Sales,
    ROUND(
        (
            Total_Sales -
            LAG(Total_Sales) OVER (ORDER BY Month)
        ) * 100.0 /
        LAG(Total_Sales) OVER (ORDER BY Month),
        2
    ) AS MoM_Growth_Percent
FROM monthly_sales
ORDER BY Month;


/*
===========================================================
KEY RESULTS FROM THE ANALYSIS

Overall:
- Total Sales      : ₹81,105,684.00
- Total Cost	   : ₹69,936,701.50
- Total Profit     : ₹11,168,982.50
- Total Orders     : 1,000
- Total Items Sold : 3,021
- Average Order Value: ₹81,105.68
- Overall Profit Margin: 13.77%

NOTE:
The profit margin above follows the dataset's Sales and Profit
values. The unusually high margin should be interpreted in
the context of how the source dataset calculates Profit.

Region:
- West  : ₹24,327,287.80
- North : ₹23,703,719.50
- East  : ₹17,065,879.35
- South : ₹16,008,797.35

Highest-Sales Region:
- West

Category:
- Electronics : ₹44,426,146.70
- Appliances  : ₹22,766,996.20
- Furniture   : ₹13,200,865.35
- Accessories : ₹711,675.75

Highest-Sales Category:
- Electronics

Category Profit Margin:
- Furniture   : 14.00%
- Electronics : 13.90%
- Appliances  : 13.40%
- Accessories : 13.04%

Highest Monthly Sales:
- September : ₹8,560,996.45

Lowest Monthly Sales:
- April : ₹5,122,105.70

===========================================================
*/