---
layout: default
title: "From API to Dashboard: Designing an End-to-End Data Pipeline with Python, PostgreSQL & Power BI"
description: Complete data pipeline from API extraction to PostgreSQL storage to Power BI dashboards.
---

# 🏗️ From API to Dashboard: Designing an End-to-End Data Pipeline with Python, PostgreSQL & Power BI

## 📌 Project Overview

In this project, I designed and built a complete end-to-end data pipeline that moves data from a REST API into a relational database and ultimately into an interactive analytics dashboard. This project demonstrates the ability to move from raw API data to analytics-ready dashboards through structured data engineering and modeling practices. Rather than focusing solely on visual outputs, this project emphasizes how thoughtful data design enables meaningful analysis.

This project demonstrates:

 - Extraction of data from a REST API
 - Transformation of nested JSON into relational tables
 - Loading of structured data into PostgreSQL
 - Performing SQL-based analysis
 - Building interactive dashboards in Power BI using DAX

Although the dataset comes from a simulated e-commerce API, the architecture and design patterns mirror real-world data engineering workflows, with a focus on how raw data becomes analytics-ready. The project covers the full stack of modern data work structured as follows:

<div style="text-align: center;">
  <img src="{{ 'assets/images/etl-architecture.png' | relative_url }}" 
       alt="ETL Architecture Diagram" 
       style="max-width: 800px; width: 100%; border-radius: 8px;">
</div>

The pipeline follows a layered architecture where data is extracted from a REST API, transformed into normalized relational tables, stored in PostgreSQL, and analyzed through both SQL queries and Power BI dashboards.

## 🔄 Phase 1 - Extraction: Working with REST APIs.
 
### What is a REST API?

A **REST API** (Representational State Transfer API) is an interface that allows applications to communicate over HTTP using a set of architectural principles known as REST.

An **API** (Application Programming Interface) defines how software systems interact. REST provides the rules for how that interaction should happen — typically through standard HTTP methods such as:

- `GET` → retrieve data
- `POST` → create data
- `PUT` → update data
- `DELETE` → remove data

Most modern REST APIs return data in **JSON** (JavaScript Object Notation) format because it is lightweight, flexible, and easy to parse in programming languages like Python.

### Making a Request in Python

In this project, I used Python’s `requests` library to retrieve data from an API endpoint as follows.

```python
import requests
import pandas as pd

url = "https://fakestoreapi.com/products/1"
response = requests.get(url)
print(response.json())
```

### Example of a JSON Response

Below is a simplified example of what an API response may look like:

```json
{
  "id": 1,
  "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
  "price": 109.95,
  "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
  "category": "men's clothing",
  "rating": {
    "rate": 3.9,
    "count": 120
  }
}
```

### Building a Reusable Extract Function

For this project, I designed a reusable extraction function that could dynamically pull different resources from the API.

For this project, I needed to extract three datasets:
- `products`
- `users`
- `carts`

Rather than hard-coding three different scripts, I built a single function that accepts an endpoint as a parameter and returns a structured DataFrame.

```python
import requests
import pandas as pd

def extract_from_api(endpoint):
    url = f"https://fakestoreapi.com/{endpoint}"
    response = requests.get(url)
    response.raise_for_status()
    return pd.DataFrame(response.json())

df_products = extract_from_api("products")
df_users = extract_from_api("users")
df_carts = extract_from_api("carts")
```

## 🧱 Phase 2 — Transformation: Normalizing Nested JSON into Relational Tables

### The Challenge of Nested Data 

After extracting raw JSON from the API, the data was not analytics-ready. The API returned nested objects and arrays, which are not ideal for relational databases. This phase went beyond typical cleaning steps such as:

- Dropping rows  
- Cleaning column names  
- Converting dates  
- Changing data types  

Instead, it required structural transformation.

For example, the API response returned the `rating` field as a **nested dictionary**:

```json
"rating": {
  "rate": 3.9,
  "count": 120
}
```
Relational databases do not store nested objects inside columns efficiently. Therefore, a key transformation step in this project was converting nested JSON into normalized relational tables. So before writing transformation code, I designed the following relational model:

| Table       | Type       | Purpose |
|------------|------------|----------|
| users      | Dimension  | Customer information |
| products   | Dimension  | Product catalog |
| carts      | Fact       | Order-level data |
| cart_items | Fact       | Line-level order details |


I then proceeded to transform the `rating` field which had to be flattened for SQL compatibility. This transformation created two new columns:

```python
df["rating_rate"] = df["rating"].apply(lambda x: x["rate"])
df["rating_count"] = df["rating"].apply(lambda x: x["count"])
df = df.drop(columns = ["rating"])
```
This ensures:

- SQL-ready columns  
- Cleaner schema  
- Easier aggregation (e.g., average rating, total review count) 

### Feature Engineering

From the API endpoints, I extracted three primary tables:

- `products`  
- `users`  
- `carts`  

However, based on the relational model design above, an additional table was required: **`cart_items`**.

Feature engineering involves creating new variables or structures from raw data to improve usability and analytical power. In this case, I engineered `cart_items` from `carts`.

**Why?** Because one cart can contain multiple products.

Storing product lists inside a single cart row would:

- Break relational principles  
- Prevent proper joins  
- Make aggregation harder  
- Introduce redundancy  

To maintain normalization, the structure had to be split.

In the original `carts` structure before normalization, The `products` field inside `carts` was a **list of dictionaries** representing a one-to-many relationship:

```json
{
  "id": 1,
  "userId": 1,
  "date": "2020-03-02T00:00:00.000Z",
  "products": [
    { "productId": 1, "quantity": 4 },
    { "productId": 2, "quantity": 1 }
  ]
}
```
To normalize this structure, I used `.explode()` which turns each element of a list into a separate row.

```python
def create_cart_items(df):
    
    cart_items = df[["id", "products"]].explode("products")

    cart_items["product_id"] = cart_items["products"].apply(lambda x: x["productId"])
    cart_items["quantity"] = cart_items["products"].apply(lambda x: x["quantity"])

    cart_items.rename(columns={"id": "cart_id"}, inplace=True)

    cart_items.drop(columns=["products"], inplace=True)

    return cart_items
```
**Before:**

| id | products  |
|----|----------|
| 1  | [p1, p2] |

**After `.explode("products")`:**

| id | products |
|----|----------|
| 1  | p1       |
| 1  | p2       |

Separating `carts` and `cart_items`, ensured that the data model now:

- Supports foreign key relationships  
- Enables accurate revenue calculations  
- Allows clean SQL joins  
- Prevents duplication

## 🗄 Phase 3 — Loading into PostgreSQL

To load the data into PostgreSQL, I used **SQLAlchemy**, a Python SQL toolkit and Object Relational Mapper (ORM) that enables applications to communicate with relational databases using Python instead of writing raw connection logic.

In simple terms, it acts as a bridge between Python (Pandas) and PostgreSQL. This connection is established by creating an **engine** - an object that allows Pandas to write directly into PostgreSQL tables.

Once connected, I used Pandas' built-in `.to_sql()` method to load each DataFrame into its respective table.

```python
engine = create_engine(
    "database_type://db_username:db_password@db_location:port/db_name"
)

df.to_sql(
    "name",
    engine,
    if_exists="replace",
    index=False
)
```

**Parameters:**

- `name` → Target table name  
- `engine` → Database connection  
- `if_exists` → Defines table behavior (e.g., replace or append)  
- `index=False` → Prevents the Pandas index from being written as a column  

## 🔎 Phase 4 — SQL Analytics Layer


With the star schema successfully loaded into PostgreSQL, the next step was validating the structure through analytical SQL queries.

Although this project focuses primarily on pipeline design rather than business analysis, this layer demonstrates that the warehouse supports:

- Multi-table joins  
- Aggregations  
- Revenue calculations  
- Customer and product-level insights  

Below are sample queries executed against the schema.

### Average Order Value

```sql
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        c.id,
        SUM(ci.quantity * p.price) AS order_total
    FROM carts c
    JOIN cart_items ci ON c.id = ci.cart_id
    JOIN products p ON ci.product_id = p.id
    GROUP BY c.id
) sub;
```

This query demonstrates layered aggregation across transactional data.

---

### Top 5 Customers by Revenue

```sql
SELECT 
    u.id,
    u.username,
    SUM(ci.quantity * p.price) AS customer_revenue
FROM users u
JOIN carts c ON u.id = c.userid
JOIN cart_items ci ON c.id = ci.cart_id
JOIN products p ON ci.product_id = p.id
GROUP BY u.id, u.username
ORDER BY customer_revenue DESC
LIMIT 5;
```

This validates the integration of fact and dimension tables within the star schema.

---

### Products Never Purchased

```sql
SELECT 
    p.id,
    p.title
FROM products p
LEFT JOIN cart_items ci 
    ON p.id = ci.product_id
WHERE ci.product_id IS NULL;
```

This query identifies dimension records that do not have corresponding fact table entries, helping validate data completeness and uncover potential gaps in transactional coverage.

## 📊 Phase 5 — Power BI Analytics Layer

After validating the warehouse in PostgreSQL, the final step was connecting the database to Power BI to build a semantic layer for reporting and interactive analysis.

This phase demonstrates how the star schema integrates into a BI tool and supports dynamic, context-aware calculations.

### Relationships in Model View

After importing the PostgreSQL tables into Power BI, relationships were defined in the **Model View**.

The schema mirrors the database design:

- `users` → Dimension  
- `products` → Dimension  
- `carts` → Fact (order-level)  
- `cart_items` → Fact (line-level)  

Relationships were created using primary and foreign keys. A **Primary Key (PK)** is a column that uniquely identifies each record in a table. It ensures that no two rows have the same identifier. A **Foreign Key (FK)** is a column that references the primary key of another table. It establishes a relationship between two tables and maintains referential integrity. In a star schema, dimension tables contain primary keys and fact tables contain foreign keys that reference those dimensions. Relationships were configured as **one-to-many (1:M)** as this mirrors real-world transactional behavior and preserves star schema integrity.

The following primary and foreign key relationships were defined:

| Primary Key (1-side) | Foreign Key (Many-side) | Relationship |
|----------------------|--------------------------|--------------|
| `users.id`           | `carts.userId`           | One user → Many carts |
| `carts.id`           | `cart_items.cart_id`     | One cart → Many cart items |
| `products.id`        | `cart_items.product_id`  | One product → Many cart items |

**Model View**

<div style="text-align: center;">
  <img src="{{ 'assets/images/Model_View _Power_BI.png' | relative_url }}" 
       alt="ETL Model View Power BI" 
       style="max-width: 800px; width: 100%; border-radius: 8px;">
</div>

### Creating DAX Measures

With relationships established, DAX measures were created to support dynamic reporting. **DAX (Data Analysis Expressions)** is a formula language used in Power BI to create calculated measures and columns. Unlike SQL, which performs aggregations at the database level, DAX calculations are evaluated dynamically based on **filter context** - meaning results change automatically depending on slicers, visuals, drilldowns, or report interactions.

Below is a sample DAX measure:

**Repeat Customers**

```DAX
Repeat Customers = 
CALCULATE(
    DISTINCTCOUNT(carts[userId]),
    FILTER(
        VALUES(carts[userId]),
        CALCULATE(COUNT(carts[id])) > 1
    )
)
```

### Interactive Dashboard & Visual Insights

The final step was building an interactive dashboard to visualize revenue, customer behavior, and product performance.

---

<div style="text-align: center;">
  <img src="{{ 'assets/images/ETL_Sales_Overview.png' | relative_url }}" 
       alt="ETL Sales Overview" 
       style="max-width: 800px; width: 100%; border-radius: 8px;">
</div>

---

<div style="text-align: center;">
  <img src="{{ 'assets/images/ETL_Product_Insights.png' | relative_url }}" 
       alt="ETL Product Insights" 
       style="max-width: 800px; width: 100%; border-radius: 8px;">
</div>

---

<div style="text-align: center;">
  <img src="{{ 'assets/images/ETL_Customer_Insights.png' | relative_url }}" 
       alt="ETL Customer Insights" 
       style="max-width: 800px; width: 100%; border-radius: 8px;">
</div>

---

## 💡 Engineering & Analytics Takeaways

This project demonstrates the full lifecycle of modern analytics engineering from API ingestion to business intelligence delivery.

### Project Steps & Actions
During this project, I carried out the following steps:

- Designed a structured ETL pipeline to extract and normalize nested JSON data from APIs  
- Transformed semi-structured API responses into relational tables ready for SQL querying  
- Engineered a star schema with fact (`cart_items`, `carts`) and dimension (`products`, `users`) tables for scalable analytics  
- Validated data integrity and business logic using analytical SQL queries  
- Built a semantic layer in Power BI using one-to-many relationships to enable accurate aggregations  
- Developed dynamic DAX measures (Total Revenue, Average Order Value, Repeat Customers) for context-aware reporting  
- Delivered an end-to-end analytics workflow from raw API data to interactive, insightful dashboards

### Key Learnings & Takeaways
Some important insights and practical lessons from the project:

**Why normalization matters:** 
Ensures data integrity, prevents redundancy, and simplifies joins for analytics 

**SQL vs DAX comparison:** 
SQL performs pre-aggregated analysis at the database level, while DAX enables dynamic, filter/context-aware calculations in Power BI  

**ETL design affects dashboard flexibility:** 
Modular, well-structured pipelines make it easier to reuse, debug, and scale analytics workflows 

**Flattening nested JSON is a real-world necessity:** 
APIs often return nested data, and flattening it is critical for relational database storage and reporting  

**Fact vs dimension tables:** 
Proper separation improves analytical clarity and performance  

**Dynamic metrics enhance BI storytelling:** 
Measures like repeat customers or average order value allow dashboards to adapt to slicers, drilldowns, and filters 

**Reusability and maintainability:** 
Creating Python functions for extraction and transformation reduces duplicated code and makes iterative development easier  

## 🛠 Tools & Technologies

**Languages & Libraries**
- Python (Pandas, SQLAlchemy)
- SQL (PostgreSQL)
- DAX (Power BI)

**Data Source**
- REST API (JSON format)

**Database**
- PostgreSQL
- DBeaver (SQL client)

**BI & Visualization**
- Power BI Desktop

## 📂 Project Files

- [`Python ETL.ipynb`](./Python%20ETL.ipynb) – Python notebook containing the ETL pipeline code  
- [`ETL SQL.sql`](./ETL%20SQL.sql) – Full SQL code for analytical queries and table validations  
- [`Power BI Analysis Dashboard.pdf`](./Power%20BI%20Analysis%20Dashboard.pdf) – Exported Power BI dashboard with visuals and DAX measures

---

> *This project is part of a personal data portfolio to demonstrate SQL data analysis skills.*

