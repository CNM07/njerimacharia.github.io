---
layout: default
title: SQL Data Analysis – Online Retail Sales
description: Analyzing customer behavior, sales performance, product insights, and market trends using SQL.
---

# 🛍️ Online Retail Sales Analysis with SQL

## 📌 Project Overview

This project focuses on analyzing sales data from an online retail store using SQL and PostgreSQL. The goal is to explore customer behavior, product performance, geographic trends, and overall sales performance to extract meaningful business insights.

It was done as part of a data analytics portfolio, showcasing skills in data cleaning, querying, and drawing insights using structured query language (SQL).

---

## 🧾 Dataset Overview

- **Source:** [UCI Machine Learning Repository - Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/online+retail)
- **Size:** ~540,000 rows
- **Period:** One year of transactional data for a UK-based online retailer
- **Fields include:**
  - InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

---

## 🎯 Objectives

The analysis aims to answer the following business questions:

### 1. Customer Value & Behavior
- Who are the top 10 customers by revenue?
- What products do they buy most?
- What is the average order size by customer?
- How often do repeat customers shop?

### 2. Sales Performance Over Time
- What are the monthly revenue trends?
- Are there seasonal patterns or revenue drops?
- Which products are trending or declining?

### 3. Best and Worst Performing Products
- What are the top products by revenue and quantity?
- Which products have many transactions but low revenue?
- Which products have few transactions but high revenue?
- What items are returned most often (Quantity < 0)?

### 4. Market/Geography Insights
- Which countries generate the most revenue?
- Which countries have the highest number of orders?

---

## 🧹 Data Cleaning Steps

Data cleaning was done using SQL (PostgreSQL), and included:

- Removing rows with missing `CustomerID`
- Filtering out rows with non-positive `Quantity` or `UnitPrice`
- Trimming whitespace and standardizing text fields (e.g., converting country names to uppercase)
- Removing duplicate rows using PostgreSQL's `ctid`
- Verifying data integrity after cleaning

---

## 🔍 Exploratory Data Analysis (EDA)

SQL queries were used to:
- Aggregate revenue by customer, product, and time period
- Identify sales trends across months
- Detect high-value customers and product patterns
- Analyze order frequencies
- Uncover regional performance

---

## 🔍 Sample SQL Queries

```sql
-- Monthly Revenue Trend
SELECT 
    DATE_TRUNC('month', InvoiceDate) AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM 
    online_retail_sales
GROUP BY 
    month
ORDER BY 
    month;
```

 ---

## 💡 Key Insights

- The top 10 customers contributed significantly to overall revenue.
- Some products are purchased often but generate low revenue, while others have fewer transactions but high value.
- There are visible seasonal spikes, especially toward the end of the year.
- The UK dominates sales volume and revenue, but other countries like the Netherlands and Germany are notable contributors.
- Many transactions lacked a `CustomerID` and were excluded from behavior analysis.
- Not all high-frequency products are high-value

---

## 🛠 Tools & Technologies

- **SQL**: PostgreSQL (via DBeaver)
- **Data Cleaning**: SQL queries for filtering, updating, and deduplication
- **Exploration**: SQL aggregations, CTEs, subqueries, window functions
- **Optional for Visualization**: Power BI (can be added later)

---

## 📁 Files

- [`sql_analysis.sql`](./sql_analysis.sql) – Full SQL code 


---

> *This project is part of a personal data portfolio to demonstrate SQL data analysis skills.*
