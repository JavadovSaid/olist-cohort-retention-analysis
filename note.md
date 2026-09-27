# Olist E-Commerce Cohort Retention & Revenue Analysis

## Executive Summary
This document provides a comprehensive analysis of customer retention, cohort acquisition dynamics, and revenue sustainability for the **Olist E-Commerce** dataset. The analysis was executed using a PostgreSQL data pipeline (Queries Q1–Q10) and processed via Python (`pandas`, `seaborn`, `matplotlib`).

The primary finding is that Olist operates as an **acquisition-driven, transactional marketplace**. Customer retention experiences an immediate and sharp drop-off following initial purchase, with repeat purchase revenue accounting for a minor fraction of overall Gross Merchandise Value (GMV).

---

## Key Performance Indicators & Baselines

| Metric | Baseline Value | Strategic Implication |
| :--- | :--- | :--- |
| **Peak Acquisition Month** | November 2017 ($7,060$ customers) | High responsiveness to seasonal sales (Black Friday) |
| **Average Period 1 Retention** | $5.45\%$ (Overall) / $<1.00\%$ (Adjusted) | Steep drop-off immediately post-purchase |
| **Long-Tail Retention Baseline** | $0.14\% - 0.45\%$ (Periods 2–19) | Stable, low-frequency repeat purchaser base |
| **Revenue Model** | Heavily Front-Loaded (Period 0 GMV) | Dependent on continuous top-of-funnel customer acquisition |

---

## Analytical Findings

### 1. Cohort Growth & Platform Scaling
* **Early Expansion (2016–2017):** The platform scaled rapidly from early single-digit cohorts (e.g., September 2016 with $1$ customer, October 2016 with $262$ customers) into consistent monthly cohorts exceeding $3,000+$ customers by mid-2017 (May 2017: $3,451$; July 2017: $3,752$).
* **Peak Acquisition (2017–2018):** November 2017 marked the highest acquisition volume with $7,060$ new delivered customers, driven by holiday promotional traffic. Acquisition sustained a baseline of $6,000$–$6,800+$ customers per month through mid-2018 (e.g., January 2018: $6,842$; March 2018: $6,774$).

### 2. Customer Retention Rates & Decay Dynamics
* **Initial Drop-Off (Period 0 to Period 1):** Period 0 retention is universally $100.00\%$. The raw mathematical average retention drops to $5.45\%$ in Period 1.
* **Outlier Adjustment:** The overall Period 1 average ($5.45\%$) is distorted by the December 2016 micro-cohort, which shows $100.00\%$ retention due to a sample size of $1$ customer.
* **Standard Operational Retention:** Across realistic, high-volume cohorts (2017–2018), Period 1 customer retention remains consistently below $1.00\%$:
  * **Top Performing Cohort:** October 2017 ($0.72\%$ retention, $31$ returning customers out of $4,328$).
  * **Lowest Performing Cohort:** February 2017 ($0.18\%$ retention, $3$ returning customers out of $1,628$).
* **Long-Tail Decay Curve (Periods 2 to 20):** After Period 1, customer activity levels off into a low, predictable range between $0.14\%$ and $0.45\%$. Minor increases at Period 20 ($0.76\%$) are small-sample variations in early 2016 cohorts.

### 3. Revenue Retention & Monetary Impact
* **Front-Loaded Revenue Distribution:** Gross Merchandise Value (GMV) is concentrated almost entirely in Period 0.
  * **January 2017 Cohort:** Generated $\$111,787.46$ in Period 0, dropping to $\$76.12$ in Period 1 and staying below $\$500.00$/month thereafter.
  * **February 2017 Cohort:** Generated $\$234,147.28$ in Period 0, falling to $\$434.90$ in Period 1 and $\$484.50$ in Period 2.
* **Business Model Confirmation:** Repeat purchase values remain negligible compared to initial acquisition revenues, confirming an **e-commerce marketplace structure driven by one-off transactions** rather than subscription or high-frequency repurchases.

---

## Business Recommendations

1. **Automated Post-Purchase Re-Engagement:** Implement targeted marketing automation (email/SMS sequences and personalized product recommendations) within 14–30 days post-delivery to convert initial buyers into repeat shoppers before Period 1 decay occurs.
2. **Category Cross-Selling Incentives:** Introduce bounce-back discount codes or shipping vouchers valid on complementary product categories to improve Customer Lifetime Value (LTV).
3. **Loyalty & Gamification Strategies:** Test a tiered loyalty or cashback program for high-value categories to establish a recurring purchase loop beyond Period 0.