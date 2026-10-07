# Credit Card Payment Behavior & Default Risk Analysis

I built this project to understand how credit exposure and payment behavior look across customers who default and customers who don't. The analysis starts in Excel, moves to MySQL for verification, and ends in a two-page Power BI dashboard.

![Power BI Dashboard - Page 1](assets/PowerBI_Page1.png)
![Power BI Dashboard - Page 2](assets/PowerBI_Page2.png)

---

## 1. Introduction

This is a credit risk analysis on 4,220 credit card customers. Each row is one customer, and the data shows their credit limit, monthly bills and payments, late-payment history, repayment status codes and whether they defaulted the next month.

I wanted to see which customer groups show higher observed default rates. I also wanted to practise a full Excel → SQL → Power BI workflow where the same numbers match at every stage.

---

## 2. Business Problem

A bank or card issuer wants to know where default risk shows up in its customer base. Some questions it might ask:

- How many customers are defaulting?
- Do customers with higher credit utilization default more often?
- Do customers with more late payments default more often?
- Do defaulting customers bill and pay differently from the rest?

This project answers these questions using only the patterns visible in this dataset.

---

## 3. Dataset

| Detail | Information |
|---|---|
| Project domain | Finance / Credit Risk |
| Customers | 4,220 (one row per customer, all CustomerIDs unique) |
| Default customers | 935 |
| Non-default customers | 3,285 |
| Overall default rate | 22.16% |
| Target field | `DefaultNextMonth` (0 = Non-Default, 1 = Default) |
| Raw columns | 21 |
| Source of the dataset | Not specified in the source dataset. |
| Currency / monetary unit | Not specified in the source dataset. |

**Fields I used from the raw data:** Age, Gender, Education, MaritalStatus, EmploymentType, MonthlyIncome, CreditLimit, MonthsWithBank, PaymentStatus_M1 / M2 / M3, BillAmount_M1 / M2 / M3, PaymentAmount_M1 / M2 / M3, CashAdvance_M1, LatePayments_6M and DefaultNextMonth.

**Fields I created:**

| Field | Rule |
|---|---|
| Age_Group | 21–29, 30–39, 40–49, 50–59, 60+ |
| Credit_Limit_Group | Low < 40M, Medium 40M to < 60M, High 60M to < 100M, Very High ≥ 100M |
| Average_Bill | Average of BillAmount_M1, M2, M3 |
| Average_Payment | Average of PaymentAmount_M1, M2, M3 |
| Credit_Utilization | Average_Bill / CreditLimit |
| Credit_Utilization_Group | Low ≤ 25%, Moderate > 25% to 50%, High > 50% to 75%, Very High > 75% to 100%, Over Limit > 100% |
| Late_Payment_Category | 0 = No Late Payments, 1–2 = Low, 3–4 = Moderate, 5+ = High |
| Credit_Utilization_Sort | Helper column used only in Excel to keep the utilization groups in order |

CardsHeld was removed from the project and is not used anywhere in the analysis.

---

## 4. Tools Used

| Tool | How I used it |
|---|---|
| Excel | Data cleaning, derived fields, Data Dictionary and PivotTables (PT01–PT06) |
| MySQL | Data validation checks and SQL queries for the six business questions |
| Power BI | Two-page interactive dashboard |
| DAX | Measures for KPIs and default rates |

---

## 5. What I Did

**Excel → SQL → Power BI**

**Excel**
- Kept the raw data in `RAW_Data` and built a `Clean_Data` sheet from it.
- Created the derived fields with formulas (age group, credit limit group, average bill, average payment, credit utilization, utilization group and late-payment category).
- Wrote a `Data_Dictionary` and a `Business_Questions` sheet.
- Built six PivotTables (PT01–PT06) in `Pivot_Analysis` to answer the business questions.

**SQL (MySQL)**
- Created a `credit_card_clean` table from the Clean_Data sheet. The Credit_Utilization_Sort helper column is left out on purpose because it is only needed for sorting in Excel.
- Ran validation checks first: row count, duplicate CustomerIDs, NULLs, and only 0/1 in DefaultNextMonth.
- Wrote one query for each business question (Q1–Q6) so the results could be matched against the Excel pivots.
- Added a small extra query for default rate by age group.

**Power BI**
- Loaded Clean_Data as a single table. There are no relationships because only one table is needed.
- Added a `Default Status` column (1 = Default, 0 = Non-Default) for the donut chart and the bill vs payment chart.
- Wrote 11 DAX measures and built
