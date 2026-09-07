/* ============================================================
   07_Advanced_Analysis.sql
   Project: E-commerce Sales Analysis
   Database: PostgreSQL

   Purpose:
   Advanced business analysis using:
   - CTEs
   - Window Functions
   - RANK()
   - CASE statements
   - Aggregations
   - Percentage calculations
   ============================================================ */


/* ============================================================
   QUERY 1: TOP PRODUCT IN EACH CATEGORY
   ============================================================

   Business Question:
   Which product generates the highest sales in each category?

   Technique:
   - SUM()
   - RANK() OVER(PARTITION BY)
   ============================================================ */

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
WHERE Product_Rank = 1
ORDER BY Category;


/* ============================================================
   QUERY 2: TOP REGION FOR EACH CATEGORY
   ============================================================

   Business Question:
   Which region generates the highest sales for each category?

   Technique:
   - GROUP BY
   - SUM()
   - RANK() OVER(PARTITION BY)
   ============================================================ */

WITH region_category_sales AS (
    SELECT
        Region,
        Category,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Region, Category
),

ranked_regions AS (
    SELECT
        Region,
        Category,
        Total_Sales,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Sales DESC
        ) AS Region_Rank
    FROM region_category_sales
)

SELECT
    Category,
    Region,
    ROUND(Total_Sales, 2) AS Total_Sales,
    Region_Rank
FROM ranked_regions
WHERE Region_Rank = 1
ORDER BY Category;


/* ============================================================
   QUERY 3: SALESPERSON RANKING BY SALES AND PROFIT
   ============================================================

   Business Question:
   How does each salesperson rank based on sales and profit?

   Technique:
   - SUM()
   - RANK()
   - Multiple window functions
   ============================================================ */

WITH salesperson_performance AS (
    SELECT
        Salesperson,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM ecommerce_sales
    GROUP BY Salesperson
)

SELECT
    Salesperson,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Total_Profit, 2) AS Total_Profit,

    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank,

    RANK() OVER (
        ORDER BY Total_Profit DESC
    ) AS Profit_Rank

FROM salesperson_performance
ORDER BY Sales_Rank;


/* ============================================================
   QUERY 4: CUSTOMER SALES RANKING
   ============================================================

   Business Question:
   Which customers generate the highest sales?

   Technique:
   - GROUP BY
   - SUM()
   - RANK()
   ============================================================ */

WITH customer_sales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Customer_ID, Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(Total_Sales, 2) AS Total_Sales,

    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Customer_Rank

FROM customer_sales
ORDER BY Customer_Rank;


/* ============================================================
   QUERY 5: CATEGORY RANKING WITHIN EACH REGION
   ============================================================

   Business Question:
   Which categories perform best within each region?

   Technique:
   - GROUP BY
   - SUM()
   - RANK() OVER(PARTITION BY)
   ============================================================ */

WITH region_category_sales AS (
    SELECT
        Region,
        Category,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Region, Category
)

SELECT
    Region,
    Category,
    ROUND(Total_Sales, 2) AS Total_Sales,

    RANK() OVER (
        PARTITION BY Region
        ORDER BY Total_Sales DESC
    ) AS Category_Rank

FROM region_category_sales
ORDER BY Region, Category_Rank;


/* ============================================================
   QUERY 6: CUSTOMER FREQUENCY SEGMENTATION
   ============================================================

   Business Question:
   How frequently do customers place orders?

   Customer Segments:
   - 1 order       = One-Time Customer
   - 2–5 orders    = Occasional Customer
   - 6–10 orders   = Frequent Customer
   - 11+ orders    = Very Frequent Customer

   Technique:
   - COUNT(DISTINCT)
   - CASE statement
   ============================================================ */

WITH customer_orders AS (
    SELECT
        Customer_ID,
        Customer_Name,
        COUNT(DISTINCT Order_ID) AS Total_Orders
    FROM ecommerce_sales
    GROUP BY Customer_ID, Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    Total_Orders,

    CASE
        WHEN Total_Orders = 1
            THEN 'One-Time Customer'

        WHEN Total_Orders BETWEEN 2 AND 5
            THEN 'Occasional Customer'

        WHEN Total_Orders BETWEEN 6 AND 10
            THEN 'Frequent Customer'

        ELSE 'Very Frequent Customer'
    END AS Customer_Frequency_Segment

FROM customer_orders
ORDER BY Total_Orders DESC;


/* ============================================================
   QUERY 7: PRODUCT VALUE CLASSIFICATION
   ============================================================

   Business Question:
   How can products be classified based on their total sales?

   Classification:
   - Sales >= 5,000,000  = High Value Product
   - Sales >= 2,000,000  = Medium Value Product
   - Sales < 2,000,000   = Low Value Product

   Technique:
   - SUM()
   - CASE statement
   ============================================================ */

WITH product_sales AS (
    SELECT
        Product,
        Category,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Product, Category
)

SELECT
    Product,
    Category,
    ROUND(Total_Sales, 2) AS Total_Sales,

    CASE
        WHEN Total_Sales >= 5000000
            THEN 'High Value Product'

        WHEN Total_Sales >= 2000000
            THEN 'Medium Value Product'

        ELSE 'Low Value Product'
    END AS Product_Value_Category

FROM product_sales
ORDER BY Total_Sales DESC;


/* ============================================================
   QUERY 8: REGION PERFORMANCE CLASSIFICATION
   ============================================================

   Business Question:
   Which regions perform above or below the average regional
   sales?

   Technique:
   - CTE
   - AVG()
   - Percentage calculation
   - CASE statement
   ============================================================ */

WITH region_sales AS (
    SELECT
        Region,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Region
),

region_percentage AS (
    SELECT
        Region,
        Total_Sales,
        ROUND(
            Total_Sales * 100.0 /
            SUM(Total_Sales) OVER (),
            2
        ) AS Sales_Percentage
    FROM region_sales
),

average_region_sales AS (
    SELECT
        AVG(Total_Sales) AS Average_Sales
    FROM region_sales
)

SELECT
    r.Region,
    ROUND(r.Total_Sales, 2) AS Total_Sales,
    r.Sales_Percentage,

    CASE
        WHEN r.Total_Sales > a.Average_Sales
            THEN 'Above Average Region'
        ELSE 'Below Average Region'
    END AS Region_Performance

FROM region_percentage r
CROSS JOIN average_region_sales a
ORDER BY r.Total_Sales DESC;


/* ============================================================
   QUERY 9: CATEGORY CONTRIBUTION WITHIN EACH REGION
   ============================================================

   Business Question:
   What percentage of each region's sales comes from each
   category?

   Technique:
   - CTE
   - Window function
   - Percentage calculation
   ============================================================ */

WITH region_category_sales AS (
    SELECT
        Region,
        Category,
        SUM(Sales) AS Category_Sales
    FROM ecommerce_sales
    GROUP BY Region, Category
)

SELECT
    Region,
    Category,
    ROUND(Category_Sales, 2) AS Category_Sales,

    ROUND(
        Category_Sales * 100.0 /
        SUM(Category_Sales) OVER (
            PARTITION BY Region
        ),
        2
    ) AS Sales_Percentage

FROM region_category_sales
ORDER BY Region, Sales_Percentage DESC;


/* ============================================================
   QUERY 10: SALESPERSON PERFORMANCE CLASSIFICATION
   ============================================================

   Business Question:
   How can salespersons be classified based on their total sales?

   Classification:
   - Sales >= 9,000,000 = Top Performer
   - Sales >= 7,500,000 = Strong Performer
   - Sales < 7,500,000  = Standard Performer

   Technique:
   - SUM()
   - CASE statement
   ============================================================ */

WITH salesperson_sales AS (
    SELECT
        Salesperson,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_sales
    GROUP BY Salesperson
)

SELECT
    Salesperson,
    ROUND(Total_Sales, 2) AS Total_Sales,

    CASE
        WHEN Total_Sales >= 9000000
            THEN 'Top Performer'

        WHEN Total_Sales >= 7500000
            THEN 'Strong Performer'

        ELSE 'Standard Performer'
    END AS Performance_Category

FROM salesperson_sales
ORDER BY Total_Sales DESC;


/* ============================================================
   KEY INSIGHTS
   ============================================================

   The following insights are based on the results generated
   from the queries above.
   ============================================================ */


/* ------------------------------------------------------------
   1. TOP PRODUCT IN EACH CATEGORY
   ------------------------------------------------------------

   Accessories  -> Webcam          : ₹300,983.75
   Appliances   -> Air Conditioner : ₹8,606,771.15
   Electronics  -> Laptop Pro 14   : ₹15,377,923.05
   Furniture    -> Sofa Set        : ₹5,134,200.30
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   2. TOP REGION FOR EACH CATEGORY
   ------------------------------------------------------------

   Accessories  -> West  : ₹311,501.00
   Appliances   -> West  : ₹6,767,714.80
   Electronics  -> North : ₹13,377,301.20
   Furniture    -> North : ₹3,984,337.30
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   3. SALESPERSON PERFORMANCE
   ------------------------------------------------------------

   Highest Sales:
   Sonia -> ₹10,536,250.85

   Highest Profit:
   Sonia -> ₹1,509,226.50

   Top 3 by Sales:
   1. Sonia -> ₹10,536,250.85
   2. Aman  -> ₹9,816,006.60
   3. Yash  -> ₹8,648,825.60
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   4. TOP CUSTOMERS BY SALES
   ------------------------------------------------------------

   1. Kavya Malhotra -> ₹1,408,933.35
   2. Manish Kumar   -> ₹1,237,852.60
   3. Rahul Sharma   -> ₹1,155,370.85
   4. Aarav Yadav    -> ₹1,011,593.60
   5. Nisha Mehta    -> ₹970,873.75
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   5. CATEGORY PERFORMANCE WITHIN REGIONS
   ------------------------------------------------------------

   Electronics is the highest-sales category in all four
   regions.

   East:
   Electronics -> ₹9,623,091.05

   North:
   Electronics -> ₹13,377,301.20

   South:
   Electronics -> ₹8,061,099.10

   West:
   Electronics -> ₹13,364,655.35

   Highest Appliances sales:
   West -> ₹6,767,714.80

   Highest Furniture sales:
   North -> ₹3,984,337.30

   Highest Accessories sales:
   West -> ₹311,501.00
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   6. CUSTOMER FREQUENCY
   ------------------------------------------------------------

   Customer frequency classification:

   1 order      -> One-Time Customer
   2–5 orders   -> Occasional Customer
   6–10 orders  -> Frequent Customer
   11+ orders   -> Very Frequent Customer

   Highest order frequency:
   Kavya Malhotra -> 17 orders

   Other very frequent customer:
   Rahul Sharma -> 11 orders
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   7. PRODUCT VALUE CLASSIFICATION
   ------------------------------------------------------------

   High Value Products:
   - Laptop Pro 14
   - LED TV 55
   - Air Conditioner
   - Smartphone X
   - Tablet Plus
   - Refrigerator
   - Washing Machine
   - Sofa Set

   Medium Value Product:
   - Bed Frame

   Low Value Products:
   - Microwave Oven
   - Study Table
   - Wireless Headphones
   - Office Chair
   - Bookshelf
   - Mixer Grinder
   - Webcam
   - Mouse
   - Keyboard
   - USB Hub
   - Phone Cover

   Highest-value product:
   Laptop Pro 14 -> ₹15,377,923.05
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   8. REGION PERFORMANCE
   ------------------------------------------------------------

   West:
   ₹24,327,287.80 -> 29.99%
   Classification: Above Average Region

   North:
   ₹23,703,719.50 -> 29.23%
   Classification: Above Average Region

   East:
   ₹17,065,879.35 -> 21.04%
   Classification: Below Average Region

   South:
   ₹16,008,797.35 -> 19.74%
   Classification: Below Average Region

   Key finding:
   West generated the highest regional sales.
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   9. CATEGORY CONTRIBUTION WITHIN REGIONS
   ------------------------------------------------------------

   Electronics contributed the largest share of sales in
   every region.

   East:
   Electronics -> 56.39%

   North:
   Electronics -> 56.44%

   South:
   Electronics -> 50.35%

   West:
   Electronics -> 54.94%

   Key finding:
   Electronics is the dominant category across all regions.
   ------------------------------------------------------------ */


/* ------------------------------------------------------------
   10. SALESPERSON PERFORMANCE CLASSIFICATION
   ------------------------------------------------------------

   Top Performers:
   - Sonia
   - Aman

   Strong Performers:
   - Yash
   - Pallavi
   - Mohit
   - Varun

   Standard Performers:
   - Kavita
   - Raj
   - Tarun
   - Deepak

   Key finding:
   Sonia is the highest-performing salesperson by total sales
   and total profit.
   ------------------------------------------------------------ */


/* ============================================================
   END OF 07_Advanced_Analysis.sql
   ============================================================ */