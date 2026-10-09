# Credit Card Payment Behavior & Default Risk Analysis

**Tools:** Microsoft Excel · MySQL 8+ · Power BI · DAX  
**Domain:** Finance and Credit Risk Analytics  
**Project type:** Descriptive and diagnostic data analytics

This project compares observed credit-card default patterns across credit-utilization groups, credit-limit groups, late-payment categories, coded payment-status values, and customer bill/payment behavior. It uses Excel for preparation and PivotTable analysis, MySQL for data validation and querying, and Power BI for reporting.

![Power BI Dashboard — Overview](assets/PowerBI_Page1.png)
![Power BI Dashboard — Overview](assets/PowerBI_Page2.png)

## 1. Business Problem

A card issuer needs to understand how observed default rates vary across its customer base and which customer/payment segments may deserve further review.

The project investigates:

- What proportion of customers in the prepared dataset are recorded as defaulting?
- How do observed default rates differ across credit-utilization and credit-limit groups?
- How do default rates vary across late-payment categories and coded payment-status values?
- How do average bill and payment amounts differ between default and non-default customers?

The analysis is intended to support investigation and monitoring, not to make automatic credit decisions.

## 2. Dataset and Source

The project started with the UCI Machine Learning Repository’s [*Default of Credit Card Clients* dataset](https://archive.ics.uci.edu/dataset/350/defaultofcreditcardclients), which contains 30,000 records and 23 features. The final analysis uses a prepared working dataset with **4,220 customer records**. During preparation, additional fields not present in the original UCI dataset—including `EmploymentType`, `MonthlyIncome`, `MonthsWithBank`, and `CashAdvance_M1`—were manually added. The project documentation does not fully record the exact rule used to select the 4,220 rows, how every added field was populated, or all steps behind the apparent monetary rescaling.

The results below describe the prepared project dataset. The added fields and rescaled monetary values should not be interpreted as verified original UCI attributes or as independently verified facts about real customers.

| Dataset characteristic | Detail |
|---|---:|
| Starting source | UCI *Default of Credit Card Clients* dataset |
| Customers in final project analysis | 4,220 |
| Default customers | 935 |
| Non-default customers | 3,285 |
| Overall observed default rate | 22.16% |
| Customer key in project file | `CustomerID` |
| Target field in project file | `DefaultNextMonth` (1 = Default, 0 = Non-Default) |
| Monetary unit | Not verified; no currency is claimed |

## 3. Tools and Methodology

### Excel

- Organized the customer data in `RAW_Data` and `Clean_Data`.
- Created fields for age groups, credit-limit groups, average bill, average payment, credit utilization, and late-payment categories.
- Documented fields in `Data_Dictionary` and analysis questions in `Business_Questions`.
- Built six PivotTables (`PT01`–`PT06`) in `Pivot_Analysis` and used them to cross-check the results.

### MySQL

- Created the `credit_card_risk` database and `credit_card_clean` table.
- Checked customer row counts, unique `CustomerID` values, NULLs, and valid `DefaultNextMonth` values.
- Queried the project’s business questions and compared outputs with the Excel PivotTables.
- Excluded `Credit_Utilization_Sort` from SQL because it is an Excel-only sorting helper.

### Power BI and DAX

- Used one customer analysis table for the report.
- Created a `Default Status` column and DAX measures for KPIs and default-rate calculations.
- Built a two-page dashboard with KPI cards, charts, slicers, and context for small customer groups.
- Added tooltip context for the small `Over Limit` utilization and `High` late-payment groups.

## 4. Metrics and Derived Fields

```text
Default Rate = Default Customers ÷ Total Customers

Average Bill = Average of BillAmount_M1, BillAmount_M2, BillAmount_M3

Average Payment = Average of PaymentAmount_M1, PaymentAmount_M2, PaymentAmount_M3

Credit Utilization = Average Bill ÷ CreditLimit
```

Project-defined grouping rules include:

| Field | Rule used in this project |
|---|---|
| `Age_Group` | 21–29, 30–39, 40–49, 50–59, and 60+ |
| `Credit_Limit_Group` | Low: < 40M; Medium: 40M to < 60M; High: 60M to < 100M; Very High: ≥ 100M |
| `Credit_Utilization_Group` | Low: ≤ 25%; Moderate: > 25% to 50%; High: > 50% to 75%; Very High: > 75% to 100%; Over Limit: > 100% |
| `Late_Payment_Category` | 0 = No Late Payments; 1–2 = Low; 3–4 = Moderate; 5+ = High |

`PaymentStatus_M1`, `PaymentStatus_M2`, and `PaymentStatus_M3` use codes from 0–3 in the current working file. Their mapping to the original UCI payment-status codes is not documented, so this README reports them as codes only. The grouping thresholds above are project-defined analytical segments, not industry-standard credit-risk rules.

## 5. Key Results

| KPI / finding | Result |
|---|---:|
| Customers analyzed | **4,220** |
| Default customers | **935** |
| Non-default customers | **3,285** |
| Overall observed default rate | **22.16%** |
| Default rate in Low-utilization group | **7.11%** |
| Default rate in Very High-utilization group | **53.70%** |
| Default rate for customers with no late payments | **4.08%** |
| Default rate in Moderate late-payment group | **80.00% (600 customers)** |
| Default rate in High late-payment group | **91.67% (24 customers)** |
| Default rate for PaymentStatus_M1 code 0 | **6.59%** |
| Default rate for PaymentStatus_M1 code 3 | **89.15%** |
| Default rate in Over Limit utilization group | **100% (9 customers)** |

### Key Findings

1. **Observed default rates differ sharply across utilization groups.** The rate ranges from 7.11% in the Low-utilization group to 53.70% in the Very High group. This is an association in the prepared dataset, not proof of causation.
2. **Late-payment categories show substantially different observed default rates.** The rate is 4.08% for customers with no late payments and 80.00% for the Moderate category (600 customers). The High category shows 91.67%, but contains only 24 customers, so its percentage should be interpreted cautiously.
3. **Payment-status code M1 is associated with different observed default rates.** The rate ranges from 6.59% for code 0 to 89.15% for code 3. The codes are shown as codes because their mapping to the original UCI values is not documented.
4. **Default and non-default customers show different bill/payment patterns.** Average bill is approximately 26.91M for default customers versus 20.88M for non-default customers; average payment is approximately 4.73M versus 8.26M. The monetary values appear rescaled, and the unit is not verified, so no currency is assigned to these figures.

### Additional Context

| Credit-limit group | Observed default rate |
|---|---:|
| Low | 24.49% |
| Medium | 22.95% |
| High | 18.77% |
| Very High | 18.52% |

The Over Limit utilization group has a 100% observed default rate but contains only 9 customers. Percentages from small groups can be unstable and should be read alongside group sizes.

## 6. Dashboard

### Page 1 — Overview

![Power BI Dashboard — Overview](assets/PowerBI_Page1.png)

Shows customer counts, overall default rate, average bill/payment, average utilization, and default comparisons across credit-limit and utilization groups.

### Page 2 — Payment Behavior and Default Risk

![Power BI Dashboard — Payment Behavior](assets/PowerBI_Page2.png)

Shows observed default rates by late-payment category and coded payment status, alongside average bills versus payments by default status.

## 7. Business Recommendations

- Use utilization and late-payment segments as starting points for further investigation, not as standalone credit-decision rules.
- Review group sizes beside default-rate percentages, especially for the Over Limit utilization group and High late-payment category.
- Explore whether the observed patterns remain after considering overlapping customer attributes and payment behavior.
- Keep payment-status codes as codes until their mapping is documented.
- Validate any proposed credit policy using additional data and appropriate risk governance before operational use.

## 8. Validation and Limitations

The project compares the main results across Excel PivotTables, MySQL queries, and Power BI. This is descriptive and diagnostic analytics: observed relationships do not establish causation, and the project does not train a machine-learning model or predict default.

- **Prepared source data:** UCI was the starting dataset, but the exact selection of 4,220 rows and the provenance of manually added fields are not fully documented.
- **Monetary values:** amounts appear rescaled relative to the original UCI scale; the monetary unit is unverified.
- **Payment-status codes:** the current file uses codes 0–3, but their mapping to the original UCI codes is not documented.

## 9. Reproducibility

- Excel workbook: `data/credit_card_analysis.xlsx`
- Clean prepared CSV: `data/credit_card_clean.csv`
- SQL analysis: `sql/credit_card_default_risk_analysis.sql`
- Power BI report: `powerbi/credit_card_risk_Dashboard.pbix`

Workflow:

1. Open the Excel workbook and review `Clean_Data`, `Data_Dictionary`, `Business_Questions`, and `Pivot_Analysis`.
2. In MySQL Workbench, run the database and table setup statements in the SQL script to create `credit_card_risk.credit_card_clean`.
3. Import `data/credit_card_clean.csv` using **Table Data Import Wizard**. Its headers should already be trimmed and consistent with the SQL table, and it should not include the Excel-only `Credit_Utilization_Sort` field.
4. Run the validation and business-question queries after the data is imported. The SQL script drops and recreates the table in its setup section; do not rerun that setup section after importing unless you intend to rebuild and reload the table.
5. Open the Power BI report and compare its KPI values with Excel and SQL results.

---

*This project describes patterns in a prepared portfolio dataset. It is not a production credit-risk system, an automated decision rule, or a default prediction model.*
