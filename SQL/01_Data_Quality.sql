/*
===========================================================
PROJECT : E-commerce Sales SQL Analysis
FILE    : 01_Data_Quality.sql
DATABASE: PostgreSQL

PURPOSE:
Validate the quality, completeness, consistency,
and basic structure of the e-commerce sales dataset.
===========================================================
*/


-- =========================================================
-- 1. CHECK TOTAL NUMBER OF RECORDS
-- =========================================================

SELECT
    COUNT(*) AS Total_Rows
FROM ecommerce_sales;


-- =========================================================
-- 2. CHECK FOR DUPLICATE ORDER IDs
-- =========================================================

SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM ecommerce_sales
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- =========================================================
-- 3. CHECK FOR NULL VALUES
-- =========================================================

SELECT
    COUNT(*) FILTER (WHERE Order_ID IS NULL) AS Null_Order_ID,
    COUNT(*) FILTER (WHERE Order_Date IS NULL) AS Null_Order_Date,
    COUNT(*) FILTER (WHERE Customer_ID IS NULL) AS Null_Customer_ID,
    COUNT(*) FILTER (WHERE Customer_Name IS NULL) AS Null_Customer_Name,
    COUNT(*) FILTER (WHERE Region IS NULL) AS Null_Region,
    COUNT(*) FILTER (WHERE State IS NULL) AS Null_State,
    COUNT(*) FILTER (WHERE Category IS NULL) AS Null_Category,
    COUNT(*) FILTER (WHERE Sub_Category IS NULL) AS Null_Sub_Category,
    COUNT(*) FILTER (WHERE Product IS NULL) AS Null_Product,
    COUNT(*) FILTER (WHERE Quantity IS NULL) AS Null_Quantity,
    COUNT(*) FILTER (WHERE Unit_Price IS NULL) AS Null_Unit_Price,
    COUNT(*) FILTER (WHERE Discount_Pct IS NULL) AS Null_Discount_Pct,
    COUNT(*) FILTER (WHERE Sales IS NULL) AS Null_Sales,
    COUNT(*) FILTER (WHERE Cost IS NULL) AS Null_Cost,
    COUNT(*) FILTER (WHERE Profit IS NULL) AS Null_Profit,
    COUNT(*) FILTER (WHERE Payment_Mode IS NULL) AS Null_Payment_Mode,
    COUNT(*) FILTER (WHERE Order_Status IS NULL) AS Null_Order_Status,
    COUNT(*) FILTER (WHERE Ship_Date IS NULL) AS Null_Ship_Date,
    COUNT(*) FILTER (WHERE Salesperson IS NULL) AS Null_Salesperson
FROM ecommerce_sales;


-- =========================================================
-- 4. CHECK ORDER DATE RANGE
-- =========================================================

SELECT
    MIN(Order_Date) AS Minimum_Order_Date,
    MAX(Order_Date) AS Maximum_Order_Date
FROM ecommerce_sales;


-- =========================================================
-- 5. CHECK REGION DISTRIBUTION
-- =========================================================

SELECT
    Region,
    COUNT(*) AS Total_Orders
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Orders DESC;


-- =========================================================
-- 6. CHECK CATEGORY DISTRIBUTION
-- =========================================================

SELECT
    Category,
    COUNT(*) AS Total_Orders
FROM ecommerce_sales
GROUP BY Category
ORDER BY Total_Orders DESC;


-- =========================================================
-- 7. CHECK ORDER STATUS DISTRIBUTION
-- =========================================================

SELECT
    Order_Status,
    COUNT(*) AS Total_Orders
FROM ecommerce_sales
GROUP BY Order_Status
ORDER BY Total_Orders DESC;


-- =========================================================
-- 8. CHECK QUANTITY RANGE AND AVERAGE
-- =========================================================

SELECT
    MIN(Quantity) AS Minimum_Quantity,
    MAX(Quantity) AS Maximum_Quantity,
    ROUND(AVG(Quantity), 2) AS Average_Quantity
FROM ecommerce_sales;


-- =========================================================
-- 9. CHECK SALES RANGE AND AVERAGE
-- =========================================================

SELECT
    MIN(Sales) AS Minimum_Sales,
    MAX(Sales) AS Maximum_Sales,
    ROUND(AVG(Sales), 2) AS Average_Sales
FROM ecommerce_sales;


-- =========================================================
-- 10. CHECK PROFIT RANGE AND AVERAGE
-- =========================================================

SELECT
    MIN(Profit) AS Minimum_Profit,
    MAX(Profit) AS Maximum_Profit,
    ROUND(AVG(Profit), 2) AS Average_Profit
FROM ecommerce_sales;


-- =========================================================
-- 11. CHECK DISCOUNT DISTRIBUTION
-- =========================================================

SELECT
    Discount_Pct,
    COUNT(*) AS Total_Orders
FROM ecommerce_sales
GROUP BY Discount_Pct
ORDER BY Discount_Pct;


-- =========================================================
-- 12. CHECK FOR NEGATIVE SALES
-- =========================================================

SELECT
    COUNT(*) AS Negative_Sales_Count
FROM ecommerce_sales
WHERE Sales < 0;


-- =========================================================
-- 13. CHECK FOR ZERO OR NEGATIVE QUANTITY
-- =========================================================

SELECT
    COUNT(*) AS Invalid_Quantity_Count
FROM ecommerce_sales
WHERE Quantity <= 0;


/*
===========================================================
DATA QUALITY SUMMARY

Expected results from our analysis:

Total Rows:
1,000

Duplicate Order IDs:
None

NULL Values:
None in the checked columns

Order Date Range:
2025-01-01 to 2025-12-31

Negative Sales:
0

Zero or Negative Quantity:
0

Discount Values:
0%, 5%, 10%, 15%, 20%

The dataset passed the basic data-quality validation checks.
===========================================================
*/