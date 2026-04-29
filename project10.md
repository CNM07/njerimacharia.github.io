---
layout: default
title: "From Web Scraping to App Development: Sentiment Analysis of Mobile Devices & Accessories Reviews (Jumia Kenya)"
description: End-to-end data project analyzing customer sentiment from Jumia Kenya reviews using NLP techniques and machine learning, with insights delivered through an interactive Streamlit app.
---

# 📱 Sentiment Analysis of Mobile Devices & Accessories Reviews (Jumia Kenya)

## 📌 Project Overview

This project is an end-to-end sentiment analysis of customer reviews for mobile devices and related accessories sold on Jumia Kenya. It combines data collection, text analytics, and application development to uncover insights into customer satisfaction, product performance, and purchasing trends.

The project is structured in three main parts:

**Part 1: Data Collection** - Web scraping product reviews and metadata from the Jumia Kenya website

**Part 2: Data Analysis & Sentiment Modeling** - Cleaning, exploring, and analyzing review data using natural language processing (NLP) techniques, including rule-based methods and machine learning models

**Part 3: Interactive Application** - Building a Streamlit app to present insights and allow users to explore sentiment trends dynamically

The goal of this project is to demonstrate the full data workflow - from raw data acquisition to insight generation and delivery - while applying both traditional analytics and text-based modeling techniques in a real-world context.

---

##

---

## 🔄 Phase 1: Data Collection (Web Scraping)

### What is Web Scraping?

Web scraping is the process of automatically extracting data from websites. Instead of manually copying information from a webpage, we use code to send a request to a website, retrieve its content, and extract the specific data we need.

This is how it works:

**1. The Request**  
We use a library like `Requests` to send a request (like a browser would) to a website’s URL. The website responds by sending back a large block of HTML - the raw structure of the page.

**2. The Parsing**  
We use `BeautifulSoup` to navigate and "sift through" that HTML. Web pages are built using **HTML tags** (like `<div>`, `<p>`, `<h1>`), which define the structure of the content.

    For example:
    - `<h1>` might contain a product name  
    - `<p>` might contain a review  
    - `<span>` might contain a price  

    With `BeautifulSoup`, we can search for specific tags or classes and extract only the data we care about.

**3. The Storage**  
Once the data is extracted, we use `Pandas` to structure it into a table format and save it as a CSV or Excel file for analysis.

In this project, web scraping is used to collect product reviews and related data from Jumia Kenya, forming the foundation for further analysis.

### Making a Request in Python

Below is a simple example using Python:

```python id="ex_scrape"
# 1. Import Necessary Libraries
import requests
from bs4 import BeautifulSoup
import pandas as pd

# 2. Get the website content
url = "https://books.toscrape.com/"
response = requests.get(url)

# 3. Turn the HTML into a searchable "Soup"
soup = BeautifulSoup(response.text, "html.parser")

# 4. Find the data (looking for <h3> tags for titles and <p> for prices)
books = []
for item in soup.find_all("article", class_="product_pod"):
    title = item.h3.a["title"]
    price = item.find("p", class_="price_color").text
    books.append({"Title": title, "Price": price})

# 5. Save it!
df = pd.DataFrame(books)
df.to_csv("books.csv", index=False)

# 6. Load and preview
books = pd.read_csv("books.csv")
books.head()
```

Example Output:

```text
        Title                                      Price
0       A Light in the Attic                     Â£51.77
1       Tipping the Velvet                       Â£53.74
2       Soumission                               Â£50.10
3       Sharp Objects                            Â£47.82
4       Sapiens: A Brief History of Humankind    Â£54.23
```

### Project Implementation

In this project, web scraping is used to collect customer reviews and product data from Jumia Kenya across multiple categories, including:

- Mobile Phones
- Tablets
- Smartwatches
- Wireless Earbuds / Headphones
- Phone Accessories (cases, chargers, power banks)

The goal is to build a structured dataset that will be used for sentiment analysis and downstream modeling.

**Step 1: Product Selection**

For each category, a set of products will be selected and their URLs used as entry points for scraping.

**Step 2: Scraping Logic**

The scraping process will involve:

1. Sending requests to product pages
2. Extracting:
    - Product name
    - Price
    - Review text
    - Ratings
3. Iterating through multiple pages where reviews are paginated

**Step 3: Saving the Data**

**Step 4: Reading in the Data**

Sample Dataset Structure


