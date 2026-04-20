---
layout: default
title: Retail Sales Analysis: Performance, Customers & Product Trends
description: An interactive Power BI dashboard analyzing retail sales performance, customer behavior, and product performance and geographic trends to uncover meaningful business insights.
---

# 🛍️ Retail Sales Performance Dashboard (Power BI)

## 📌 Project Overview

This project explores transactional retail data to better understand sales performance, customer behavior, and product trends.

Rather than focusing solely on reporting metrics, the goal was to design a clean, interactive dashboard that highlights key patterns and supports quick, informed decision-making.

Using Power BI, I transformed raw transactional data into a structured model, created key business metrics, and built a dashboard that balances clarity, usability, and insight.

The result is a visual summary of performance across time, products, customers, and regions - with the flexibility to explore each area in more detail through interactive filtering.

It was done as part of a data analytics portfolio, showcasing skills in data cleaning, data modelling, and building interactive dashboards using Power BI.

---

## 🧾 Dataset Overview

- **Source:** [UCI Machine Learning Repository - Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/online+retail)
- **Size:** ~540,000 rows
- **Period:** One year of transactional data for a UK-based online retailer
- **Fields include:**
  - InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

---

## 🔹 1. Data Preparation - Making the Data Usable

Before building anything, I focused on getting the data into a reliable and analysis-ready state.

This involved:

- Creating a **Total Sales** column from `Quantity × UnitPrice`  
- Converting `InvoiceDate` into a proper date format and extracting time components  
- Handling missing values, particularly **null Customer IDs**, to avoid misleading insights  
- Ensing correct data types across all fields  

This step was critical because even small inconsistencies (like null identifiers or incorrect formats) can significantly affect aggregations and rankings later in the analysis.

---

## 🔹 2. Core Metrics & Data Modelling

Once the data was clean, I moved on to defining the core metrics that would drive the entire dashboard.

Rather than relying on raw fields, I created calculated measures to reflect how the business would actually track performance.

Key metrics included:

- **Total Sales** → overall revenue generated  
- **Total Orders** → number of unique transactions  
- **Average Order Value (AOV)** → average revenue per order  
- **Total Quantity Sold** → overall sales volume  

These metrics form the foundation of most retail analysis — balancing both **revenue (value)** and **volume (activity)**.

---

### Example DAX Measures

```DAX
Total Sales = 
SUMX(
    'SalesData',
    'SalesData'[Quantity] * 'SalesData'[UnitPrice]
)
```
This measure ensures revenue is calculated at row level before aggregation, avoiding incorrect totals.

```DAX
Average Order Value = 
DIVIDE(
    [Total Sales],
    [Total Orders]
)
```

This metric helps contextualize revenue by showing how much each order contributes on average — a key indicator of customer purchasing behavior.

These measures allowed me to move beyond basic summaries and build a dashboard that reflects how the business actually performs, not just what the raw data contains.

 ---

## 🔹 3. Visual Structure, Design & Layout

With the metrics in place, I focused on structuring the dashboard in a way that is clear, intuitive, and easy to scan.

The layout was designed in layers:

### 🔸 Top Section - Key Metrics

I placed KPI cards at the top to provide an immediate snapshot of performance:

- Total Sales  
- Total Orders  
- Average Order Value  
- Total Quantity Sold  

This allows a user to understand overall performance within seconds.

---

### 🔸 Middle Section - Core Insights

The main visuals focus on answering the most important business questions:

- **Sales Trend Over Time** → to identify patterns, growth, or seasonality  
- **Top Products by Sales** → to understand revenue drivers  
- **Sales by Country (Map)** → to highlight geographic performance  

---

### 🔸 Bottom Section - Supporting Insights

Additional visuals provide deeper context:

- **Top Customers by Sales** → identifying high-value customers  
- **Most Purchased Product (by Quantity)** → highlighting volume leaders  

One key insight here is the distinction between:

- High-revenue products  
- High-volume products  

This difference helps reveal pricing dynamics and product strategy opportunities.

---

### 🔸 Interactivity

To make the dashboard more flexible, I added slicers for:

- Month  
- Country  
- Product  

These allow users to quickly filter and explore specific segments without overwhelming the layout.

---

## 📊 Dashboard Preview

<div style="background-color: #FFFFFF; padding: 16px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08);">

![Retail Sales Dashboard](../assets/images/retail-dashboard.png)

<p style="text-align: center; font-size: 14px; color: #6B7280; margin-top: 8px;">
Interactive Power BI dashboard showing sales performance, customer insights, and product trends across time and regions.
</p>

</div>

---

## 💡 Key Analytics Insights

- Sales are concentrated in a few top-performing countries, with The United Kingdom leading revenue generation - €9M in sales. 
 - The highest revenue-generating products differ from the most purchased products, indicating pricing differences across items. The most purchased product by quantity ranks only 3rd place in total sales, suggesting lower unit price.
- Sales trend shows seasonality over time, with peaks observed in November 2011 and declines in both February and April of the same year.

---

## 🛠 Tools & Technologies

- **Power BI**
- **Power Query** (data cleaning & transformation)
- **DAX** (calculated measures)

---

## 📁 Files

- [`retail_dashboard.pbix`](./retail_dashboard.pbix) – Power BI project file

---

> *This project is part of a personal data portfolio to demonstrate Power BI data analysis and visualization skills.*
