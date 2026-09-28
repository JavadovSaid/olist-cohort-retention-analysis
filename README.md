# Olist E-Commerce Cohort Retention & Revenue Analysis

An end-to-end data analytics project evaluating customer acquisition, cohort retention decay, and gross merchandise value (GMV) sustainability for the Olist E-Commerce dataset in Brazil.

---

## Executive Summary

This project analyzes customer lifecycle behavior and revenue retention across **100,000+ orders** on the Olist marketplace. By building a PostgreSQL data extraction pipeline and processing the metrics in Python, we evaluated how effectively the platform retains buyers over a 20-month period.

### Key Findings
* **Transactional Business Model:** Olist functions primarily as a single-purchase marketplace rather than a subscription-driven platform.
* **Immediate Retention Drop-Off:** After initial delivery (Period 0), customer retention drops sharply to **<1.00%** across standard high-volume cohorts.
* **Front-Loaded Revenue:** The vast majority of Gross Merchandise Value (GMV) is generated during the initial purchase period, with minimal repeat purchase monetization in subsequent months.

---

## Key Performance Indicators

| Metric | Metric Value | Strategic Context |
| :--- | :--- | :--- |
| **Peak Acquisition Cohort** | November 2017 ($7,060$ buyers) | Strong seasonal pull during Black Friday events |
| **Period 1 Retention Rate** | $<1.00\%$ (Adjusted Baseline) | Immediate churn post-purchase; single-order dominant |
| **Long-Tail Retention** | $0.14\% - 0.45\%$ (Periods 2–19) | Small, stable baseline of recurring buyers |
| **Revenue Concentration** | $>99\%$ in Period 0 | Top-of-funnel acquisition dependency |

---

## Repository Structure

```text
├── data/                  # Database schematics & raw dataset references
├── sql/                   # PostgreSQL analytical queries (Q1–Q10)
│   ├── retention_matrix.sql
│   └── revenue_cohorts.sql
├── notebooks/             # Python Jupyter notebooks
│   └── cohort_analysis.ipynb
├── note.md                # Detailed analytical findings and technical notes
└── README.md              # Project overview and executive summary
