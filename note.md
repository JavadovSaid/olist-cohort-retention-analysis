# Olist E-Commerce Cohort Retention & Revenue Analysis

## Executive Summary
This document provides a comprehensive analysis of customer retention, cohort acquisition dynamics, and revenue sustainability for the **Olist E-Commerce** dataset[cite: 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]. The analysis was executed using a PostgreSQL data pipeline (Queries Q1–Q10) and processed via Python (`pandas`, `seaborn`, `matplotlib`)[cite: 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].

The primary finding is that Olist operates as an **acquisition-driven, transactional marketplace**[cite: 5, 6, 8, 9, 10]. Customer retention experiences an immediate and sharp drop-off following initial purchase, with repeat purchase revenue accounting for a minor fraction of overall Gross Merchandise Value (GMV)[cite: 5, 6, 8, 9, 10].

---

## Key Performance Indicators & Baselines

| Metric | Baseline Value | Strategic Implication |
| :--- | :--- | :--- |
| **Peak Acquisition Month** | November 2017 ($7,060$ customers)[cite: 3, 7] | High responsiveness to seasonal sales (Black Friday)[cite: 3, 7] |
| **Average Period 1 Retention** | $5.45\%$ (Overall)[cite: 5, 6] / $<1.00\%$ (Adjusted)[cite: 6, 7, 11] | Steep drop-off immediately post-purchase[cite: 5, 6, 7, 11] |
| **Long-Tail Retention Baseline** | $0.14\% - 0.45\%$ (Periods 2–19)[cite: 5, 6, 10] | Stable, low-frequency repeat purchaser base[cite: 5, 6, 10] |
| **Revenue Model** | Heavily Front-Loaded (Period 0 GMV)[cite: 8, 9] | Dependent on continuous top-of-funnel customer acquisition[cite: 8, 9] |

---

## Analytical Findings

### 1. Cohort Growth & Platform Scaling
* **Early Expansion (2016–2017):** The platform scaled rapidly from early single-digit cohorts (e.g., September 2016 with $1$ customer[cite: 3, 4], October 2016 with $262$ customers[cite: 3, 4]) into consistent monthly cohorts exceeding $3,000+$ customers by mid-2017 (May 2017: $3,451$[cite: 3]; July 2017: $3,752$[cite: 3, 7]).
* **Peak Acquisition (2017–2018):** November 2017 marked the highest acquisition volume with $7,060$ new delivered customers, driven by holiday promotional traffic[cite: 3, 7]. Acquisition sustained a baseline of $6,000$–$6,800+$ customers per month through mid-2018 (e.g., January 2018: $6,842$[cite: 3, 7]; March 2018: $6,774$[cite: 3, 7]).

### 2. Customer Retention Rates & Decay Dynamics
* **Initial Drop-Off (Period 0 to Period 1):** Period 0 retention is universally $100.00\%$[cite: 5, 6, 11]. The raw mathematical average retention drops to $5.45\%$ in Period 1[cite: 5, 6].
* **Outlier Adjustment:** The overall Period 1 average ($5.45\%$) is distorted by the December 2016 micro-cohort, which shows $100.00\%$ retention due to a sample size of $1$ customer[cite: 6, 7].
* **Standard Operational Retention:** Across realistic, high-volume cohorts (2017–2018), Period 1 customer retention remains consistently below $1.00\%$[cite: 6, 7, 11]:
  * **Top Performing Cohort:** October 2017 ($0.72\%$ retention, $31$ returning customers out of $4,328$)[cite: 6, 7].
  * **Lowest Performing Cohort:** February 2017 ($0.18\%$ retention, $3$ returning customers out of $1,628$)[cite: 6, 7].
* **Long-Tail Decay Curve (Periods 2 to 20):** After Period 1, customer activity levels off into a low, predictable range between $0.14\%$ and $0.45\%$[cite: 5, 6, 10]. Minor increases at Period 20 ($0.76\%$) are small-sample variations in early 2016 cohorts[cite: 2, 4, 5, 6, 10, 11].

### 3. Revenue Retention & Monetary Impact
* **Front-Loaded Revenue Distribution:** Gross Merchandise Value (GMV) is concentrated almost entirely in Period 0[cite: 8, 9].
  * **January 2017 Cohort:** Generated $\$111,787.46$ in Period 0[cite: 8, 9], dropping to $\$76.12$ in Period 1[cite: 8, 9] and staying below $\$500.00$/month thereafter[cite: 8, 9].
  * **February 2017 Cohort:** Generated $\$234,147.28$ in Period 0[cite: 8, 9], falling to $\$434.90$ in Period 1[cite: 8, 9] and $\$484.50$ in Period 2[cite: 8, 9].
* **Business Model Confirmation:** Repeat purchase values remain negligible compared to initial acquisition revenues[cite: 8, 9], confirming an **e-commerce marketplace structure driven by one-off transactions** rather than subscription or high-frequency repurchases[cite: 5, 6, 8, 9, 10].

---

## Business Recommendations

1. **Automated Post-Purchase Re-Engagement:** Implement targeted marketing automation (email/SMS sequences and personalized product recommendations) within 14–30 days post-delivery to convert initial buyers into repeat shoppers before Period 1 decay occurs.
2. **Category Cross-Selling Incentives:** Introduce bounce-back discount codes or shipping vouchers valid on complementary product categories to improve Customer Lifetime Value (LTV).
3. **Loyalty & Gamification Strategies:** Test a tiered loyalty or cashback program for high-value categories to establish a recurring purchase loop beyond Period 0.