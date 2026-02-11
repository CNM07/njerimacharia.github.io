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









