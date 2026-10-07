Credit Card Payment Behavior & Default Risk Analysis
A beginner-friendly data analytics project that uses Excel, MySQL and Power BI to understand customer credit-card payment behavior and observed default risk.
[Power BI Page 1](assets/PowerBI_Page1.png) | [Power BI Page 2](assets/PowerBI_Page2.png)
1. Introduction
This project looks at customer credit, billing, payment and late-payment data to answer simple business questions about default risk, credit utilization, credit-limit groups and payment behavior.
I took the project from data cleaning and analysis to SQL validation and an interactive Power BI dashboard.
2. Business Problem
A credit business needs a simple way to understand questions like:
- How many customers are defaulting?
- How does default rate vary across credit-limit groups?
- Does default rate increase with credit utilization?
- How does late-payment behavior relate to default?
- How does payment status relate to default?
- How do average bill and payment amounts differ between default and non-default customers?
The goal is to create one clear view of customer credit exposure and payment behavior, so higher-risk patterns can be identified for further review.
3. Dataset
Source: Final 4,220-row project dataset used for the analysis.
The project uses one customer-level analysis table with 4,220 unique customers. The monetary unit/currency is not specified in the source data, so no currency is assumed.
Item	Detail
Customers	4,220
Default Customers	935
Non-Default Customers	3,285
Default Rate	22.16%
Analysis Table	Clean_Data
Customer Key	CustomerID
Payment Status	Coded values 0–3; business meaning not defined in the source


4. Tools Used
Tool	What I used it for
Excel	Data cleaning, calculated fields, business questions and PivotTable analysis
MySQL	Validation, KPI calculations and answering business questions
Power BI and DAX	KPI measures, interactive slicers, charts and the final dashboard


5. What I Did
Raw Data → Excel → MySQL → Power BI
- Excel: cleaned and organized the customer data, created analysis fields such as age groups, credit-limit groups, average bill, average payment, credit utilization and late-payment categories, and built PivotTables for validation.
- SQL: loaded the cleaned data into MySQL, validated the dataset and answered the six project business questions using simple, readable SQL.
- Power BI: connected the validated data, created DAX measures, added slicers and built a two-page dashboard for overall default risk and payment behavior.
6. Metrics I Created
Default Rate              = Default Customers ÷ Total Customers

Average Bill              = Average of BillAmount_M1, M2 and M3

Average Payment           = Average of PaymentAmount_M1, M2 and M3

Credit Utilization        = Average Bill ÷ CreditLimit

Age Group                 = 21–29, 30–39, 40–49, 50–59, 60+

Credit Limit Group        = Low, Medium, High, Very High

Late Payment Category     = No Late Payments, Low, Moderate, High

Utilization Group         = Low, Moderate, High, Very High, Over Limit
7. Business Questions
1. How many customers are defaulting?
2. How does default vary across credit-limit groups?
3. How does default vary with late-payment behavior?
4. How does default vary across credit-utilization groups?
5. How does recent repayment status relate to default?
6. How do average bill amounts and payment amounts differ between default and non-default customers?
8. Key Insights
- 935 of 4,220 customers are classified as default, giving an overall default rate of 22.16%.
- Credit utilization shows a strong observed relationship with default rate: 7.11% for Low utilization, 31.85% for High, 53.70% for Very High, and 100.00% for Over Limit. The Over Limit group contains only 9 customers.
- Late-payment behavior shows a sharp increase in observed default rates: 4.08% with no late payments, 80.00% for Moderate, and 91.67% for High late payments. The High group contains 24 customers.
- Defaulters have higher average bills but lower average payments: 26.91M vs 20.88M in average bill, and 4.73M vs 8.26M in average payment compared with non-defaulters.
- Payment Status M1 shows different observed default rates across coded values: 6.59% at Status 0 and 89.15% at Status 3. The source does not define the business meaning of codes 0–3.
9. Dashboard
Page 1 — Overview
The overview page contains:
- Total Customers
- Default Customers
- Default Rate
- Average Bill
- Average Payment
- Average Credit Utilization
- Default Rate by Credit Limit Group
- Default vs Non-Default Customers
- Default Rate by Credit Utilization Group
- Slicers for customer segmentation
[View Page 1 Screenshot](assets/PowerBI_Page1.png)
Page 2 — Payment Behavior & Default Risk
The second page contains:
- Default Rate by Late Payment Category
- Default Rate by Payment Status M1
- Average Bill vs Average Payment by Default Status
- Key Observations
- Slicers for payment and customer segmentation
[View Page 2 Screenshot](assets/PowerBI_Page2.png)
10. Project Validation
The project was validated across all three phases:
Excel → SQL → Power BI
The final reconciliation confirms that the major KPIs and business-question results match across the three tools.
[SQL Verification Screenshot](assets/SQL_Verification.png)
[Excel Pivot Analysis](assets/Excel_Pivot_Analysis.png)
11. Project Files
- [Excel Workbook](data/credit_card_ Project.xlsx)
- [SQL Analysis](sql/Credit_Card_Payment_Default_Risk_Analysis.sql)
- [Power BI Dashboard](powerbi/credit_card_risk_Dashboard.pbix)
12. Important Note
The findings in this project represent observed patterns in the dataset and do not prove causation.
The project is designed as a portfolio analysis to demonstrate an end-to-end workflow using Excel, SQL and Power BI.
