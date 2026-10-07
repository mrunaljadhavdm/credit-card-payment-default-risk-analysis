# Credit Card Payment Behavior & Default Risk Analysis

A beginner-friendly data analytics project that uses **Excel, MySQL and Power BI** to understand customer credit exposure, payment behavior and observed credit-card default risk.

![Power BI Page 1](assets/PB1.png)

## 1. Introduction

This project looks at customer credit, billing, payment and late-payment data to understand **default patterns and payment behavior**.

I took the project from raw data to **data cleaning, analysis, SQL validation, business insights and an interactive Power BI dashboard**.

The analysis focuses on understanding where default rates are higher across different customer and payment-behavior groups.

---

## 2. Business Problem

A credit business needs a simple way to answer questions like:

- How many customers are defaulting?
- How does default vary across credit-limit groups?
- How does default vary with late-payment behavior?
- How does default vary across credit-utilization groups?
- How does payment status relate to default?
- How do average bills and payments differ between default and non-default customers?

The goal is to create **one clear view of customer credit exposure, payment behavior and observed default risk**, so higher-risk patterns can be identified for further review.

---

## 3. Dataset

Source: **Final project dataset used for the analysis**.

The project uses a customer-level dataset containing credit, billing and payment information.

The currency or monetary unit is **not specified in the source dataset**, so no currency is assumed in the analysis.

| Item | Detail |
|---|---|
| Customers | 4,220 |
| Default Customers | 935 |
| Non-Default Customers | 3,285 |
| Default Rate | 22.16% |
| Analysis Table | Clean_Data |
| Customer Key | CustomerID |
| Payment Status | Coded values 0–3; business meaning is not defined in the source |

The final analysis uses **4,220 unique customer records**.

> **Note:** `CardsHeld` was removed from the project and is not used anywhere in the analysis.

---

## 4. Tools Used

| Tool | What I used it for |
|---|---|
| Excel | Data cleaning, derived fields, business questions and PivotTable analysis |
| MySQL | Data validation, KPI calculations and business-question analysis |
| Power BI | Interactive dashboard, slicers, charts and visual analysis |
| DAX | KPI and analysis measures in Power BI |

---

## 5. What I Did

`Raw Data → Excel → MySQL → Power BI`

- **Excel:** cleaned and organized the data, created analysis fields such as age groups, credit-limit groups, average bill, average payment, credit utilization and late-payment categories, and built PivotTables for validation.
- **SQL:** loaded the cleaned data into MySQL, validated the dataset and answered the six business questions using simple SQL.
- **Power BI:** connected the validated data, created DAX measures, added slicers and built a two-page interactive dashboard.
- **Validation:** reconciled the important results across Excel, SQL and Power BI.

---

## 6. Metrics I Created

```text
Default Rate
= Default Customers ÷ Total Customers

Average Bill
= AVERAGE(BillAmount_M1, BillAmount_M2, BillAmount_M3)

Average Payment
= AVERAGE(PaymentAmount_M1, PaymentAmount_M2, PaymentAmount_M3)

Credit Utilization
= Average_Bill ÷ CreditLimit

Age Group
= 21–29, 30–39, 40–49, 50–59, 60+

Credit Limit Group
= Low, Medium, High, Very High

Late Payment Category
= No Late Payments, Low, Moderate, High

Credit Utilization Group
= Low, Moderate, High, Very High, Over Limit
