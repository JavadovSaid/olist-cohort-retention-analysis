# Olist E-Commerce Cohort Retention & Revenue Analysis

An end-to-end data analytics project evaluating customer acquisition, cohort retention decay, and gross merchandise value (GMV) sustainability for the Olist E-Commerce dataset in Brazil.

---

## Executive Summary

This project analyzes customer lifecycle behavior and revenue retention across **100,000+ orders** on the Olist marketplace. By building a PostgreSQL data extraction pipeline and processing the metrics in Python, we evaluated how effectively the platform retains buyers over a 20-month period[cite: 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].

### Key Findings
* **Transactional Business Model:** Olist functions primarily as a single-purchase marketplace rather than a subscription-driven platform[cite: 5, 6, 8, 9, 10].
* **Immediate Retention Drop-Off:** After initial delivery (Period 0), customer retention drops sharply to **<1.00%** across standard high-volume cohorts[cite: 5, 6, 7, 11].
* **Front-Loaded Revenue:** The vast majority of Gross Merchandise Value (GMV) is generated during the initial purchase period, with minimal repeat purchase monetization in subsequent months.

---

## Key Performance Indicators

| Metric | Metric Value | Strategic Context |
| :--- | :--- | :--- |
| **Peak Acquisition Cohort** | November 2017 ($7,060$ buyers) | Strong seasonal pull during Black Friday events[cite: 3, 7] |
| **Period 1 Retention Rate** | $<1.00\%$ (Adjusted Baseline) | Immediate churn post-purchase; single-order dominant[cite: 5, 6, 7, 11] |
| **Long-Tail Retention** | $0.14\% - 0.45\%$ (Periods 2–19) | Small, stable baseline of recurring buyers[cite: 5, 6, 10] |
| **Revenue Concentration** | $>99\%$ in Period 0 | Top-of-funnel acquisition dependency[cite: 8, 9] |

---

## Repository Structure

```text
├── Data/                                  # Olist CSV raw datasets
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
├── .gitignore                             # Git ignore configuration
├── analysis.ipynb                         # Jupyter Notebook with data processing & charts
├── create_db.py                           # Python script for PostgreSQL database creation
├── note.md                                # Detailed analytical findings and notes
├── queries.sql                            # Full SQL query pipeline (Q1–Q10)
└── README.md                              # Portfolio presentation & project overview
