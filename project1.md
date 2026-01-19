---
layout: default
title: Data Cleaning & EDA - World Happiness Report
description: |
  Exploring global happiness trends, uncovering key drivers of well-being, 
  and analyzing regional differences through data cleaning and exploratory data analysis (EDA).
---

# 🌍 World Happiness Report (Python Data Cleaning & EDA Project)

## 📌 Project Overview

This project explores the World Happiness Report dataset using Python for data cleaning and exploratory data analysis (EDA).
The aim is to uncover patterns and insights into how factors such as GDP, social support, health, freedom, and corruption 
perception influence happiness levels across countries.

It was completed as part of a data analytics portfolio, demonstrating skills in data wrangling, visualization, and 
deriving insights from real-world data using Python.

---

## 🧾 Dataset Overview

- **Source:** [World Happiness Report](https://www.kaggle.com/datasets/unsdsn/world-happiness)
- **Size:** Varies by year (approx. 150+ countries per report)
- **Period:** Annual survey data (2015–2021)
- **Fields include:**
  - Country, Year, Happiness Score, GDP per Capita, Social Support, Healthy Life Expectancy, Freedom of Choice,
    Generosity, Perceptions of Corruption

---

## 🎯 Objectives

The EDA aims to uncover the following insights:

### 1. Overall Trends
- Which countries are consistently happiest/unhappiest?
- How has global happiness changed over time?

### 2. Feature Relationships
- Does GDP per capita strongly correlate with happiness?
- Do social factors (trust, freedom, social support) matter more than money?

### 3. Regional Insights
- Compare Africa vs Europe vs Asia → what drives differences?
- How does Kenya compare to neighbors (Tanzania, Uganda, Rwanda, Ethiopia)?

### 4. Outliers & Surprises
- Countries that are happier than expected given their GDP.
- Countries with low happiness despite wealth.

---

## 🧹 Data Cleaning Taks

- Inspected yearly datasets individually to identify schema and naming inconsistencies.
- Standardized column names across years for consistency and readability (e.g., Economy..GDP.per.Capita. → gdp_per_capita).
- Aligned schemas and merged multi-year files into a single consolidated dataset.
- Added a year column to enable time-based analysis.
- Verified and enforced correct data types for all numeric fields.
- Handled missing values using logical imputation (e.g., country-level averages across years).
- Standardized country names and derived continent-level regions for geographic analysis.
- Performed final data integrity checks (nulls, duplicates, consistency).

---

## 🔍 Exploratory Data Analysis (EDA) Visuals
- Bar Chart: Top 10 happiest vs unhappiest countries.
- Line Chart: Average global happiness trend (2015 → 2023).
- Heatmap: Correlation between happiness and other features.
- Scatter Plot: GDP per capita vs Happiness (with regional color coding).
- Boxplot: Regional distributions of happiness scores.

---

## 💡 Key Insights

---

## 🛠 Tools & Technologies

- **SQL**: Data analysis and exploration (Pandas, NumPy)
- **Data Cleaning**: Handling missing values, renaming columns, and ensuring consistency
- **Exploration**: Descriptive statistics, correlation analysis, and visualizations (Matplotlib, Seaborn)

---

## 📁 Files

---

> *This project is part of a personal data portfolio to demonstrate python data analysis and cleaning skills.*
