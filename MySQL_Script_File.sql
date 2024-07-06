-- Count the total number of entries in the table
SELECT COUNT(*) FROM wallmat_clean_data.walmartsalesdata_cleaned;

-- Display the first 10 rows of the table
SELECT * FROM wallmat_clean_data.walmartsalesdata_cleaned LIMIT 10;

-- =====================================================================================================================================
-- Total Sales and Transactions:
SELECT SUM(total) AS total_sales, AVG(total) AS average_sales_per_transaction, COUNT(*) AS total_transactions
FROM wallmat_clean_data.walmartsalesdata_cleaned;

-- =======================================================================================================================================

-- Analysis List ----

-- 1. Sales Trend Analysis
-- Total and Average Sales by Branch and City
SELECT branch, city, SUM(total) AS Total_Sales, AVG(total) AS Average_Sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY branch, city;

-- Sales Trends Over Time (Monthly)
SELECT EXTRACT(YEAR FROM date) AS Year, EXTRACT(MONTH FROM date) AS Month,
       SUM(total) AS Total_Sales,
       AVG(total) AS Average_Sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date);

-- Weekly Sales Analysis:
SELECT YEAR(date) AS year, WEEK(date) AS week, SUM(total) AS weekly_sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY YEAR(date), WEEK(date)
ORDER BY YEAR(date), WEEK(date);

-- Daily Sales Analysis
SELECT date, 
       SUM(total) AS Total_Sales,
       AVG(total) AS Average_Sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY date
ORDER BY date;

-- Average Daily Sales Analysis:
SELECT day_name AS day_of_week, AVG(total) AS average_sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- ==========================================================================================================================================
-- 2. Customer Segmentation Analysis
SELECT customer_type, gender, branch,
    COUNT(*) AS Number_of_Transactions,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    AVG(quantity) AS Average_Quantity_Purchased
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY customer_type, gender, branch
ORDER BY customer_type, gender, branch;

-- Segment customers based on purchasing patterns
-- RFM Data Preparation:
SELECT customer_type, DATEDIFF(CURDATE(), MAX(date)) AS recency,
    COUNT(invoice_id) AS frequency,
    SUM(total) AS monetary
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY customer_type;

-- ======================================================================================================================================
-- 3. Product Analysis
-- Best performing product lines and how unit price and quantity impact sales.
SELECT product_line, AVG(unit_price) AS Average_Unit_Price,
    SUM(quantity) AS Total_Quantity_Sold,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sale_Per_Transaction,
    COUNT(*) AS Number_of_Transactions
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY product_line
ORDER BY Total_Sales DESC;

-- ===========================================================================================================================================
-- 4. Time Series Analysis: 
-- Examine how sales trends vary by day, month, and year, including seasonality effects.

-- Daily Sales Analysis
SELECT 
    DATE(date) AS Sales_Date,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    COUNT(*) AS Number_of_Transactions
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY Sales_Date
ORDER BY Sales_Date;

-- Monthly Sales Analysis
SELECT EXTRACT(YEAR FROM date) AS Year, EXTRACT(MONTH FROM date) AS Month,
       SUM(total) AS Total_Sales,
       AVG(total) AS Average_Sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date);

-- Yearly Sales Analysis
SELECT 
    EXTRACT(YEAR FROM date) AS Year, 
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    COUNT(*) AS Number_of_Transactions
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY EXTRACT(YEAR FROM date)

-- ====================================================================================================================================
-- 5. Operational Insights on Payment Methods
SELECT payment,
    COUNT(*) AS Number_of_Transactions,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    MIN(total) AS Min_Sale,
    MAX(total) AS Max_Sale
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY payment
ORDER BY Total_Sales DESC;

-- =======================================================================================================================================
-- 6. Payment Analysis: 
-- Study the distribution of different payment methods and their correlation with sales amounts.
-- Look how different payment methods influence purchasing behaviors or how they are preferred for specific types of purchases.

SELECT payment, product_line, customer_type, gender,
    COUNT(*) AS Number_of_Transactions,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    MIN(total) AS Min_Sale,
    MAX(total) AS Max_Sale
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY payment, product_line, customer_type, gender
ORDER BY payment, Total_Sales DESC;

-- ==========================================================================================================================================

-- Business Questions to Answer

-- Q1. How do sales figures vary across different branches and why?

-- Analyzing Sales Performance by Branch
SELECT branch,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    COUNT(*) AS Number_of_Transactions,
    AVG(quantity) AS Average_Quantity,
    AVG(unit_price) AS Average_Unit_Price
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY branch
ORDER BY Total_Sales DESC;

-- Sales by Branch and Product Line
SELECT branch, product_line,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    COUNT(*) AS Number_of_Transactions
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY branch, product_line
ORDER BY branch, Total_Sales DESC;

-- Sales by Branch and Customer Type
SELECT branch, customer_type,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    COUNT(*) AS Number_of_Transactions
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY branch, customer_type
ORDER BY branch, Total_Sales DESC;

-- ============================================================================================================================================================================
-- Q2. What are the key differences in purchasing behavior among different demographic groups?
-- Analyze various metrics such as average sales, total sales, quantity purchased, and product preferences across different demographic segments like gender and customer type. 

-- Analyzing Purchasing Behavior by Demographic Groups
SELECT customer_type, gender,
    AVG(total) AS Average_Sales,
    SUM(total) AS Total_Sales,
    AVG(quantity) AS Average_Quantity,
    COUNT(*) AS Number_of_Transactions,
    SUM(quantity * unit_price) / SUM(quantity) AS Weighted_Average_Price
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY customer_type, gender
ORDER BY customer_type, gender;

-- Product Line Preferences
SELECT customer_type, gender, product_line,
    SUM(quantity) AS Total_Quantity,
    COUNT(*) AS Number_of_Transactions,
    AVG(total) AS Average_Sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY customer_type, gender, product_line
ORDER BY customer_type, gender, Total_Quantity DESC;

-- ===========================================================================================================================
-- Q3. Which products are most popular, and what is their profitability?
-- Analyze both the volume of sales (popularity) and the gross income or profit margins (profitability) for each product line. 

-- Product Popularity and Profitability
SELECT product_line,
    SUM(quantity) AS Total_Quantity_Sold,
    SUM(gross_income) AS Total_Profit,
    AVG(gross_income) AS Average_Profit_Per_Product,
    SUM(total) AS Total_Revenue,
    (SUM(gross_income) / SUM(total)) * 100 AS Profit_Percentage
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY product_line
ORDER BY Total_Quantity_Sold DESC;

-- ==================================================================================================================================
-- Q4. How do seasonal trends affect sales in different product lines?
-- Aggregate sales data by product line and by time periods that represent different seasons.

-- Seasonal Sales Analysis by Product Line
SELECT product_line, EXTRACT(YEAR FROM date) AS Year,
    CASE 
        WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Fall'
        WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
    END AS Season,
    SUM(quantity) AS Total_Quantity_Sold,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sale_Per_Transaction
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY product_line, EXTRACT(YEAR FROM date), 
    CASE 
        WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Fall'
        WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
    END
ORDER BY product_line, Year, Season;

-- ====================================================================================================================================
-- Q5. What payment methods are most prevalent, and how do they correlate with other factors like total sales or customer types?
-- Aggregate data based on payment method and examine its relationship with sales performance and customer demographics.

-- Analyzing Prevalence of Payment Methods and Correlations
SELECT payment, customer_type,
    COUNT(*) AS Number_of_Transactions,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales,
    MAX(total) AS Max_Sale,
    MIN(total) AS Min_Sale
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY payment, customer_type
ORDER BY Number_of_Transactions DESC, Total_Sales DESC;

-- Explore the correlation between payment methods and sales across different demographics or product lines.
-- Payment Methods and Product Lines

SELECT payment, product_line,
    COUNT(*) AS Number_of_Transactions,
    SUM(total) AS Total_Sales,
    AVG(total) AS Average_Sales
FROM wallmat_clean_data.walmartsalesdata_cleaned
GROUP BY payment, product_line
ORDER BY payment, Total_Sales DESC;

-- ===================================================================================================================