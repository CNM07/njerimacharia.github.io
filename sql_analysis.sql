-- Online Retail Sales Analysis
-- Skills: Data Cleaning, Aggregations, Joins, Window Functions, Subqueries
-- Focus: Customer insights, product performance, revenue trends, and geography.
-- Tool: PostgreSQL with DBeaver


-- STEP 1: Create Table

CREATE TABLE online_retail_sales (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(100)
);

-- Preview data

SELECT * 
FROM public.online_retail_sales 
LIMIT 10;

-- STEP 2: Data Cleaning

-- 1. Remove rows with NULL CustomerID

SELECT COUNT(*) 
FROM online_retail_sales ors 
WHERE CustomerID IS NULL; 
-- 135,080 transactions are missing CustomerID 

DELETE FROM online_retail_sales
WHERE CustomerID IS NULL;

-- 2.Filter out negative or zero values in Quantity and UnitPrice

select COUNT(*)
FROM online_retail_sales
WHERE Quantity <= 0;
-- 8,905

select COUNT(*)
FROM online_retail_sales
WHERE UnitPrice <= 0;
-- 44

DELETE 
FROM online_retail_sales
WHERE Quantity <= 0 OR UnitPrice <= 0;

-- 3. Trim any leading or trailing spaces in string fields

UPDATE public.online_retail_sales
SET description=TRIM(description), country=TRIM(country);

-- 4. Standardize text fields

UPDATE online_retail_sales
SET Country = UPPER(Country);

-- 5. Check for duplicate rows

DELETE FROM online_retail_sales
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM online_retail_sales
    GROUP BY InvoiceNo, StockCode, CustomerID, InvoiceDate, Quantity, UnitPrice
);
-- ctid is a special PostgreSQL system column that helps identify individual rows.

-- Verification

-- Verify no negative values
SELECT * FROM online_retail_sales
WHERE Quantity <= 0 OR UnitPrice <= 0;

-- Check for NULL values
SELECT * FROM online_retail_sales
WHERE CustomerID IS NULL OR InvoiceNo IS NULL;

-- Check for duplicates
-- SELECT COUNT(DISTINCT *) FROM online_retail_sales;


-- STEP 4: Exploratory Data Analysis

-- 1. Understanding Customer Value and Behavior
-- Goal: Help the business identify who their most valuable customers are and how to retain them

-- a. Top 10 Customers by Revenue

SELECT CustomerID, ROUND(SUM(Quantity * UnitPrice), 1) AS TotalRevenue
FROM online_retail_sales
GROUP BY CustomerID
ORDER BY TotalRevenue DESC
LIMIT 10;

-- b. Most Bought Products by Top 10 Customers
WITH TopCustomers AS (
    SELECT CustomerID
    FROM online_retail_sales
    GROUP BY CustomerID
    ORDER BY SUM(Quantity * UnitPrice) DESC
    LIMIT 10
)
SELECT ors.CustomerID, ors.Description, SUM(ors.Quantity) AS TotalPurchased
FROM online_retail_sales ors
JOIN TopCustomers tc ON tc.CustomerID = ors.CustomerID
GROUP BY ors.CustomerID, ors.Description
ORDER BY ors.CustomerID, TotalPurchased DESC;

-- c. Average Order Size(Amount) by Customer
WITH Orders AS (
    SELECT CustomerID, InvoiceNo, SUM(Quantity * UnitPrice) AS TotalOrder
    FROM online_retail_sales
    GROUP BY CustomerID, InvoiceNo
)
SELECT CustomerID, ROUND(AVG(TotalOrder), 2) AS AvgOrder
FROM Orders
GROUP BY CustomerID;

-- d. How Often Do Repeat Customers Shop?
-- We’ll count how many unique invoices each customer has (i.e., how many times they ordered).

SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS NumberOfOrders,
    MIN(InvoiceDate) AS FirstPurchase,
    MAX(InvoiceDate) AS LastPurchase
FROM 
    online_retail_sales
GROUP BY 
    CustomerID
HAVING 
    COUNT(DISTINCT InvoiceNo) > 1
ORDER BY 
    NumberOfOrders DESC;


-- 2. Sales Performance Over Time
-- Goal: Analyze how the business is performing over different time periods.

-- a. Monthly Revenue Trends

SELECT DATE_TRUNC('month', InvoiceDate) AS Month,
       ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM online_retail_sales
GROUP BY Month
ORDER BY Month;

select to_char(invoicedate, 'month') as month,
ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
from online_retail_sales ors 
where quantity > 0 AND unitprice  > 0
group by month
order by month;

-- b. Find Months with Revenue Drops (compared to previous month)
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', InvoiceDate) AS month,
        ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
    FROM 
        online_retail_sales
    GROUP BY 
        month
)
SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(total_revenue - LAG(total_revenue) OVER (ORDER BY month), 2) AS revenue_change
FROM 
    monthly_revenue
ORDER BY 
    month;


-- c. Product Trends — Top Products Over Time

SELECT 
    DATE_TRUNC('month', InvoiceDate) AS month,
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM 
    online_retail_sales
WHERE 
    Description IS NOT NULL
GROUP BY 
    month, Description
ORDER BY 
    month, total_revenue DESC;


-- 3. Best and Worst Performing Products
-- Goal: Identify what’s driving (or hurting) revenue.

-- a. Top products by revenue and quantity sold.
-- Top products by revenue
SELECT Description, 
       SUM(Quantity * UnitPrice) AS TotalRevenue
FROM online_retail_sales
GROUP BY Description
ORDER BY TotalRevenue DESC
LIMIT 10;

-- Top products by quantity sold
SELECT Description, 
       SUM(Quantity) AS TotalQuantity
FROM online_retail_sales
GROUP BY Description
ORDER BY TotalQuantity DESC
LIMIT 10;

-- b. Products with Many Transactions but Low Revenue
SELECT 
    description,
    COUNT(*) AS num_transactions
FROM 
    online_retail_sales
GROUP BY 
    Description
ORDER BY 
    num_transactions DESC
LIMIT 1;
SELECT 
    description,
    COUNT(*) AS num_transactions
FROM 
    online_retail_sales
GROUP BY 
    Description
ORDER BY 
    num_transactions
LIMIT 1;
SELECT 
    description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM 
    online_retail_sales
GROUP BY 
    Description
ORDER BY 
    total_revenue ASC
LIMIT 1;
SELECT 
    description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM 
    online_retail_sales
GROUP BY 
    Description
ORDER BY 
    total_revenue DESC
LIMIT 1;

SELECT 
    Description,
    COUNT(*) AS num_transactions,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM 
    online_retail_sales
WHERE 
    Quantity > 0 AND UnitPrice > 0 AND Description IS NOT NULL
GROUP BY 
    Description
HAVING 
    COUNT(*) > 100 AND SUM(Quantity * UnitPrice) < 500
ORDER BY 
    num_transactions DESC;

-- c. Products with Few Transactions but High Revenue
SELECT 
    Description,
    COUNT(*) AS num_transactions,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM 
    online_retail_sales
WHERE 
    Quantity > 0 AND UnitPrice > 0 AND Description IS NOT NULL
GROUP BY 
    Description
HAVING 
    COUNT(*) < 20 AND SUM(Quantity * UnitPrice) > 2000
ORDER BY 
    total_revenue DESC;

-- 4. Market/Geography Insights
-- Goal: Help the company understand where their best customers are from.

-- a. Which countries generate the most revenue?
SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 0) AS total_revenue
FROM 
    online_retail_sales
GROUP BY 
    Country
ORDER BY 
    total_revenue DESC;

-- b. Which countries have the most orders?
SELECT 
    Country,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM 
    online_retail_sales
GROUP BY 
    Country
ORDER BY 
    total_orders DESC;
