\# E-Commerce Sales Analysis Using PostgreSQL



\## 📌 Project Overview



This project analyzes an e-commerce sales dataset containing 1,000 orders from 2025.



The project was created to practice and demonstrate SQL skills using PostgreSQL, with a focus on data quality checking, sales analysis, customer analysis, product performance, salesperson performance, order status analysis, and advanced business analysis.



The analysis transforms raw transactional data into actionable business insights related to sales performance, customer behavior, product performance, regional trends, order status, and salesperson performance.



\---



\## 🎯 Business Objectives



The main objectives of this project are to:



\- Validate the quality and consistency of the source data.

\- Analyze overall sales, profit, orders, and items sold.

\- Identify the highest-performing regions and categories.

\- Analyze monthly sales trends and month-over-month growth.

\- Identify top customers and customer purchasing behavior.

\- Analyze product sales, profit, and profitability.

\- Evaluate salesperson performance.

\- Analyze order status distribution and performance.

\- Identify top products within each category.

\- Compare category performance across regions.

\- Segment customers based on order frequency.

\- Classify products based on sales value.

\- Rank salespersons and customers using SQL window functions.

\- Generate actionable business insights from the data.



\---



\## 📊 Dataset Information



The dataset contains \*\*1,000 e-commerce orders\*\* covering the period:



\*\*January 1, 2025 – December 31, 2025\*\*



\### Dataset Features



The dataset contains the following columns:



\- Order\_ID

\- Order\_Date

\- Customer\_ID

\- Customer\_Name

\- Region

\- State

\- Category

\- Sub\_Category

\- Product

\- Quantity

\- Unit\_Price

\- Discount\_Pct

\- Sales

\- Cost

\- Profit

\- Payment\_Mode

\- Order\_Status

\- Ship\_Date

\- Salesperson



\### Dataset Summary



\- \*\*Total Orders:\*\* 1,000

\- \*\*Total Items Sold:\*\* 3,021

\- \*\*Regions:\*\* 4

\- \*\*Categories:\*\* 4

\- \*\*Order Statuses:\*\* 5

\- \*\*Salespersons:\*\* 10

\- \*\*Date Range:\*\* January 2025 – December 2025



\---



\## 🛠️ Tools \& Technologies



\- \*\*Database:\*\* PostgreSQL

\- \*\*SQL Environment:\*\* pgAdmin 4

\- \*\*Language:\*\* SQL

\- \*\*Dataset Format:\*\* CSV



\---


## Analysis Performed

### 1. Data Quality Analysis

Performed checks for:

- Duplicate Order IDs
- NULL values
- Date range
- Invalid quantities
- Negative sales
- Discount distribution
- Data consistency

### 2. Sales Analysis

Analyzed:

- Total sales
- Total profit
- Total orders
- Total items sold
- Average Order Value
- Region-wise sales
- Category-wise sales
- Monthly sales
- Month-over-month growth

### 3. Customer Analysis

Analyzed:

- Top customers by sales
- Customer order frequency
- Customer segmentation
- Repeat vs one-time customers

### 4. Product Analysis

Analyzed:

- Top products by sales
- Product profitability
- Product profit margin
- Category-wise product performance
- High-, medium-, and low-value products

### 5. Salesperson Analysis

Analyzed:

- Salesperson sales
- Salesperson profit
- Number of orders handled
- Average Order Value
- Salesperson ranking
- Performer classification

### 6. Order Status Analysis

Analyzed:

- Order-status distribution
- Sales by order status
- Profit by order status
- Returned and cancelled orders
- Region-wise returned/cancelled orders

### 7. Advanced Analysis

Performed:

- Top product by category
- Top category by region
- Salesperson ranking
- Customer ranking
- Customer frequency classification
- Product value classification
- Region performance classification
- Category contribution by region
- Salesperson performance classification

---

## 💡 SQL Skills Demonstrated

This project demonstrates practical use of:

- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate functions: SUM(), COUNT(), AVG(), MIN(), MAX()
- CASE WHEN statements
- INNER JOIN / LEFT JOIN
- Subqueries and CTEs
- Window functions
- RANK(), DENSE_RANK(), ROW_NUMBER()
- LAG()
- PARTITION BY
- Date and time functions
- Percentage calculations
- Customer and product segmentation
- Conditional classification
- Data quality validation
- Business-oriented SQL analysis


# Key Business Insights

## Overall Performance

- **Total Sales:** ₹81,105,684.00
- **Total Cost:** ₹69,936,701.50
- **Total Profit:** ₹11,168,982.50
- **Profit Margin:** 13.77%
- **Total Orders:** 1,000
- **Total Items Sold:** 3,021
- **Average Order Value:** ₹81,105.68


## Regional Performance

- West generated the highest sales: ₹24,327,287.80
- North generated the second-highest sales: ₹23,703,719.50
- West contributed 29.99% of total sales.
- North contributed 29.23% of total sales.

## Category Performance

- Electronics was the highest-selling category with ₹44,426,146.70.
- Electronics contributed 54.78% of total sales.
- Appliances generated ₹22,766,996.20.
- Furniture generated ₹13,200,865.35.
- Accessories generated ₹711,675.75.

## Product Performance

- Laptop Pro 14 was the highest-selling product with ₹15,377,923.05.
- LED TV 55 generated ₹12,517,317.35.
- Air Conditioner generated ₹8,606,771.15.
- Webcam was the highest-selling Accessories product.

## Salesperson Performance

- Sonia generated the highest sales: ₹10,536,250.85.
- Sonia also generated the highest profit: ₹1,509,226.50.
- Sonia handled the highest number of orders: 119.
- Varun had the highest Average Order Value among salespeople: ₹95,021.72.
- Sonia and Aman were classified as Top Performers.
- Yash, Pallavi, Mohit, and Varun were classified as Strong Performers.

## Customer Insights

- Kavya Malhotra was the highest-value customer with ₹1,408,933.35 in sales.
- Kavya Malhotra also placed the highest number of orders: 17.
- Manish Kumar ranked second by customer sales.
- The analysis identified customers based on purchasing frequency.

## Order Status

- 694 orders were Delivered, representing 69.40% of all orders.
- 111 orders were Shipped.
- 102 orders were Processing.
- 50 orders were Returned.
- 43 orders were Cancelled.

## Advanced Insights

- Electronics was the top-selling category across all four regions.
- West had the highest sales in Appliances and Accessories.
- North had the highest sales in Electronics and Furniture.
- West and North were classified as Above Average Regions.
- East and South were classified as Below Average Regions.


\---


\## 📁 Project Structure



```text

Ecommerce-Sales-SQL-Analysis/

│

├── Data/

│   └── Ecommerce\_Sales\_SQL\_Project\_1000\_Rows.csv

│

├── SQL/

│   ├── 01\_Data\_Quality.sql

│   ├── 02\_Sales\_Analysis.sql

│   ├── 03\_Customer\_Analysis.sql

│   ├── 04\_Product\_Analysis.sql

│   ├── 05\_Salesperson\_Analysis.sql

│   ├── 06\_Order\_Status\_Analysis.sql

│   └── 07\_Advanced\_Analysis.sql

│

└── README.md


---

## 📌 Conclusion

This project demonstrates how PostgreSQL can be used to transform raw e-commerce transaction data into meaningful business insights.

The analysis covers the complete workflow from data quality validation to sales, customer, product, salesperson, order-status, and advanced business analysis.

The project also demonstrates practical SQL techniques such as aggregation, filtering, joins, CTEs, subqueries, window functions, ranking, date analysis, and conditional segmentation.


---

## 👤 Author

**Sushant Kumar**

Aspiring Data Analyst | SQL | Excel | Power BI