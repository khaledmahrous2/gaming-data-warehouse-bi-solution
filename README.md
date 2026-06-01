
# Gaming Data Warehouse & Business Intelligence Solution

## Overview

This project demonstrates the design and implementation of an end-to-end Business Intelligence solution for a gaming platform using the Microsoft BI Stack.

The project transforms a normalized OLTP gaming database into a dimensional Data Warehouse optimized for analytics and reporting. The solution includes ETL pipelines, data cleansing and transformation processes, dimensional modeling, SSAS semantic modeling, and interactive Power BI dashboards.

---

## Technology Stack

* SQL Server
* SQL Server Integration Services (SSIS)
* SQL Server Analysis Services (SSAS Tabular)
* Power BI
* T-SQL
* Data Warehouse Modeling

---

## Architecture

Source OLTP Database

↓

Operational Data Store (ODS)

↓

Staging Layer (STG)

↓

Data Warehouse (Star Schema)

↓

SSAS Tabular Model

↓

Power BI Dashboards

---

## ETL Process

### ODS Layer

The Operational Data Store (ODS) layer receives raw data extracted from the source system without applying transformations. This layer preserves source data integrity and enables traceability.

### STG Layer

The Staging layer performs:

* Data Cleaning
* Data Validation
* Handling Missing Values
* Data Type Conversion
* Standardization
* Business Rule Transformations
* Duplicate Handling

### Data Warehouse Layer

The Data Warehouse layer loads transformed data into dimensional structures including:

#### Fact Tables

* FACT_ORDERS
* FACT_GAMEPLAY

#### Dimension Tables

* DIM_USER_INFO
* DIM_GAME_DETAILS
* DIM_DATE
* DIM_DEVICE
* DIM_PAYMENT_METHOD
* DIM_TROPHY_TYPE

The warehouse uses surrogate keys and Star Schema architecture to improve analytical performance.

---

## SSAS Tabular Model

The SSAS semantic model was built to provide a business-friendly analytical layer.

Implemented features include:

* Table Relationships
* DAX Measures
* Calculated Columns
* Aggregations
* Business KPIs

---

## Power BI Dashboards

### Sales Analytics Dashboard

Key Metrics:

* Total Sales
* Net Revenue
* Total Orders
* Total Discount
* Revenue Trends
* Revenue by Platform
* Top Countries by Sales
* Top Games by Revenue

### Gameplay Analytics Dashboard

Key Metrics:

* Total Gameplay Hours
* Active Players
* Total Sessions
* Average Session Duration
* Device Distribution
* Most Played Games
* Player Engagement Analysis

### Trophy Analytics Dashboard

Key Metrics:

* Total Trophies Earned
* Average Trophies per Player
* Gold / Silver / Bronze Distribution
* Top Players by Trophies
* Trophy Category Analysis

---

## Business Value

This solution enables gaming stakeholders to:

* Monitor sales performance
* Analyze player engagement
* Measure platform performance
* Track gameplay behavior
* Evaluate trophy achievements
* Support data-driven decision making

---

## Project Highlights

✔ End-to-End BI Solution

✔ Microsoft BI Stack

✔ SSIS ETL Pipelines

✔ SSAS Tabular Modeling

✔ Data Warehouse Design

✔ Star Schema Architecture

✔ Surrogate Key Implementation

✔ Interactive Power BI Dashboards

---

## Author

Amin Mahrous

Data Engineering & Business Intelligence Project
