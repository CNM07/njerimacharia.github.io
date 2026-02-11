---
layout: default
title: "From API to Dashboard: Designing an End-to-End Data Pipeline with Python, PostgreSQL & Power BI"
description: Complete data pipeline from API extraction to PostgreSQL storage and Power BI dashboards for sales, product, and customer insights.
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
  <img src="{{ '/assets/images/etl-architecture.png' | relative_url }}" 
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

The challenge of nested data 









