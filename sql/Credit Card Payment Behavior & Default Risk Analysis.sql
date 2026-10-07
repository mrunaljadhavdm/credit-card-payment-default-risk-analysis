/* =====================================================================
   PROJECT : Credit Card Payment Behavior & Default Risk Analysis
   PHASE   : 2 - SQL (MySQL 8)
   SOURCE  : Clean_Data sheet of the completed Excel workbook
             (4,220 customers, one row = one customer)
   GOAL    : Understand credit exposure and payment behavior and find
             observed patterns linked with DefaultNextMonth.
             (DefaultNextMonth: 1 = Default, 0 = Non-Default)

   NOTE    : Results show patterns in this dataset only. They do not
             prove that any one factor causes default.
             Every result in Sections 3 and 4 should be cross-checked
             with the Excel Pivot_Analysis sheet (PT01 to PT06).
   ===================================================================== */


/* =====================================================================
   SECTION 1 - TABLE SETUP
   ===================================================================== */

CREATE DATABASE IF NOT EXISTS credit_card_risk;
USE credit_card_risk;

DROP TABLE IF EXISTS credit_card_clean;

-- One row = one customer.
-- Column names match the Clean_Data sheet, except Credit_Utilization_Sort.
-- That column is left out on purpose: it is only an Excel helper used to
-- sort the utilization groups in a PivotTable. SQL sorts them with CASE.
CREATE TABLE credit_card_clean (
    CustomerID               VARCHAR(10) PRIMARY KEY,
    Age                      INT,
    Gender                   VARCHAR(10),
    Education                VARCHAR(20),
    MaritalStatus            VARCHAR(15),
    EmploymentType           VARCHAR(20),
    MonthlyIncome            INT,
    CreditLimit              INT,
    MonthsWithBank           INT,
    PaymentStatus_M1         INT,
    PaymentStatus_M2         INT,
    PaymentStatus_M3         INT,
    BillAmount_M1            INT,
    BillAmount_M2            INT,
    BillAmount_M3            INT,
    PaymentAmount_M1         INT,
    PaymentAmount_M2         INT,
    PaymentAmount_M3         INT,
    CashAdvance_M1           INT,
    LatePayments_6M          INT,
    DefaultNextMonth         TINYINT,
    Age_Group                VARCHAR(10),
    Average_Bill             DECIMAL(15,2),
    Average_Payment          DECIMAL(15,2),
    Credit_Utilization       DECIMAL(10,6),
    Credit_Utilization_Group VARCHAR(15),
    Late_Payment_Category    VARCHAR(20),
    Credit_Limit_Group       VARCHAR(15)
);

/* Loading the data (the original workbook is not changed):
   1. Copy the Clean_Data values into a new sheet and delete the
      Credit_Utilization_Sort column (it is not in the SQL table).
   2. In that copy, set every number column to General or Number format
      with no thousands separator. CSV saves what the cell shows, so
      accounting-formatted cells would be saved as text like " 58,000,000 ".
      Credit_Utilization must be a decimal such as 0.5234, not 52.34%.
   3. Save the copy as CSV UTF-8.
   4. In MySQL Workbench, right-click credit_card_clean > Table Data
      Import Wizard > select the CSV > map the columns by name > finish.
*/

-- Quick look at the first rows
SELECT *
FROM credit_card_clean
LIMIT 10;


/* =====================================================================
   SECTION 2 - DATA VALIDATION
   ===================================================================== */

-- Business Question: Were all customers loaded?
-- Business Use: Confirms the load is complete before any analysis starts.
-- Expected: 4,220 rows, same as Clean_Data.
SELECT
    COUNT(*)  AS total_customers,
    4220      AS expected_customers
FROM credit_card_clean;


-- Business Question: Is every CustomerID unique?
-- Business Use: One row must be one customer, otherwise counts and rates will be wrong.
SELECT
    COUNT(*)                              AS total_rows,
    COUNT(DISTINCT CustomerID)            AS unique_customers,
    COUNT(*) - COUNT(DISTINCT CustomerID) AS duplicate_rows
FROM credit_card_clean;

-- Business Question: Which CustomerIDs appear more than once (if any)?
-- Business Use: Lists the duplicate IDs so they can be checked. No rows = no duplicates.
SELECT
    CustomerID,
    COUNT(*) AS times_found
FROM credit_card_clean
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- Business Question: Are there NULL values in the columns used in this analysis?
-- Business Use: NULLs would change averages and group counts, so they are checked first.
-- Expected: every count is 0.
SELECT
    SUM(CASE WHEN CustomerID               IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN Age_Group                IS NULL THEN 1 ELSE 0 END) AS null_age_group,
    SUM(CASE WHEN EmploymentType           IS NULL THEN 1 ELSE 0 END) AS null_employment_type,
    SUM(CASE WHEN CreditLimit              IS NULL THEN 1 ELSE 0 END) AS null_credit_limit,
    SUM(CASE WHEN Credit_Limit_Group       IS NULL THEN 1 ELSE 0 END) AS null_credit_limit_group,
    SUM(CASE WHEN LatePayments_6M          IS NULL THEN 1 ELSE 0 END) AS null_late_payments,
    SUM(CASE WHEN Late_Payment_Category    IS NULL THEN 1 ELSE 0 END) AS null_late_category,
    SUM(CASE WHEN Credit_Utilization       IS NULL THEN 1 ELSE 0 END) AS null_utilization,
    SUM(CASE WHEN Credit_Utilization_Group IS NULL THEN 1 ELSE 0 END) AS null_utilization_group,
    SUM(CASE WHEN PaymentStatus_M1         IS NULL THEN 1 ELSE 0 END) AS null_payment_status,
    SUM(CASE WHEN Average_Bill             IS NULL THEN 1 ELSE 0 END) AS null_average_bill,
    SUM(CASE WHEN Average_Payment          IS NULL THEN 1 ELSE 0 END) AS null_average_payment,
    SUM(CASE WHEN DefaultNextMonth         IS NULL THEN 1 ELSE 0 END) AS null_default_flag
FROM credit_card_clean;


-- Business Question: Does DefaultNextMonth contain only 0 and 1?
-- Business Use: The default rate depends on this column (0 = Non-Default, 1 = Default).
SELECT
    DefaultNextMonth,
    COUNT(*) AS customers
FROM credit_card_clean
GROUP BY DefaultNextMonth
ORDER BY DefaultNextMonth;

-- Any value other than 0 or 1 would be counted here. Expected: 0.
SELECT COUNT(*) AS invalid_default_values
FROM credit_card_clean
WHERE DefaultNextMonth NOT IN (0, 1);


-- Business Question: Do the Over Limit labels agree with utilization above 100%?
-- Business Use: Checks the utilization group against the utilization value in both directions.
-- Expected: both counts are 0.
SELECT
    SUM(CASE WHEN Credit_Utilization > 1
              AND Credit_Utilization_Group <> 'Over Limit' THEN 1 ELSE 0 END) AS above_100_not_labelled,
    SUM(CASE WHEN Credit_Utilization_Group = 'Over Limit'
              AND Credit_Utilization <= 1 THEN 1 ELSE 0 END)                  AS labelled_but_not_above_100
FROM credit_card_clean;


/* =====================================================================
   SECTION 3 - MAIN KPIs
   ===================================================================== */

-- Business Question: What is the overall size and default level of the customer base?
-- Business Use: Gives the headline numbers
--               (Default Rate = Default Customers / Total Customers).
SELECT
    COUNT(*)                                                       AS total_customers,
    SUM(CASE WHEN DefaultNextMonth = 1 THEN 1 ELSE 0 END)          AS default_customers,
    SUM(CASE WHEN DefaultNextMonth = 0 THEN 1 ELSE 0 END)          AS non_default_customers,
    ROUND(SUM(DefaultNextMonth) * 100.0 / COUNT(*), 2)             AS default_rate_pct,
    ROUND(AVG(CreditLimit), 2)                                     AS avg_credit_limit,
    ROUND(AVG(Average_Bill), 2)                                    AS avg_bill,
    ROUND(AVG(Average_Payment), 2)                                 AS avg_payment,
    ROUND(AVG(Credit_Utilization) * 100, 2)                        AS avg_credit_utilization_pct
FROM credit_card_clean;


/* =====================================================================
   SECTION 4 - SIX BUSINESS QUESTIONS (match Pivot_Analysis PT01 - PT06)
   ===================================================================== */

-- ---------------------------------------------------------------------
-- Q1. How many customers are defaulting?      (Excel: PT01)
-- ---------------------------------------------------------------------
-- Business Question: How many customers default and how many do not?
-- Business Use: Shows the size of the default problem for the whole portfolio.
SELECT
    DefaultNextMonth,
    CASE WHEN DefaultNextMonth = 1 THEN 'Default' ELSE 'Non-Default' END AS customer_status,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_card_clean), 2) AS pct_of_customers
FROM credit_card_clean
GROUP BY DefaultNextMonth
ORDER BY DefaultNextMonth;


-- ---------------------------------------------------------------------
-- Q2. How does default vary across credit-limit groups?      (Excel: PT02)
-- ---------------------------------------------------------------------
-- Business Question: Is the default rate different for Low, Medium, High and Very High credit limits?
-- Business Use: Shows which credit exposure bands have more defaulting customers.
SELECT
    Credit_Limit_Group,
    COUNT(*)                                                AS total_customers,
    SUM(CASE WHEN DefaultNextMonth = 0 THEN 1 ELSE 0 END)   AS non_default_customers,
    SUM(CASE WHEN DefaultNextMonth = 1 THEN 1 ELSE 0 END)   AS default_customers,
    ROUND(SUM(DefaultNextMonth) * 100.0 / COUNT(*), 2)      AS default_rate_pct
FROM credit_card_clean
GROUP BY Credit_Limit_Group
ORDER BY CASE Credit_Limit_Group
             WHEN 'Low'       THEN 1
             WHEN 'Medium'    THEN 2
             WHEN 'High'      THEN 3
             WHEN 'Very High' THEN 4
         END;


-- ---------------------------------------------------------------------
-- Q3. How does default vary with late-payment behavior?      (Excel: PT03)
-- ---------------------------------------------------------------------
-- Business Question: Do customers with more late payments in 6 months default more often?
-- Business Use: Shows whether payment delay history is linked with default.
-- Note: the High group is small (24 customers), so read its rate with care.
SELECT
    Late_Payment_Category,
    COUNT(*)                                                AS total_customers,
    SUM(CASE WHEN DefaultNextMonth = 0 THEN 1 ELSE 0 END)   AS non_default_customers,
    SUM(CASE WHEN DefaultNextMonth = 1 THEN 1 ELSE 0 END)   AS default_customers,
    ROUND(SUM(DefaultNextMonth) * 100.0 / COUNT(*), 2)      AS default_rate_pct
FROM credit_card_clean
GROUP BY Late_Payment_Category
ORDER BY CASE Late_Payment_Category
             WHEN 'No Late Payments' THEN 1
             WHEN 'Low'              THEN 2
             WHEN 'Moderate'         THEN 3
             WHEN 'High'             THEN 4
         END;


-- ---------------------------------------------------------------------
-- Q4. How does default vary across credit-utilization groups?   (Excel: PT04)
-- ---------------------------------------------------------------------
-- Business Question: Is the default rate different when customers use more of their credit limit?
-- Business Use: Shows whether heavy credit usage goes together with higher default.
-- Note: Credit_Utilization = Average_Bill / CreditLimit.
--       Over Limit is very small (9 customers), so read its 100% with care.
SELECT
    Credit_Utilization_Group,
    COUNT(*)                                                AS total_customers,
    SUM(CASE WHEN DefaultNextMonth = 0 THEN 1 ELSE 0 END)   AS non_default_customers,
    SUM(CASE WHEN DefaultNextMonth = 1 THEN 1 ELSE 0 END)   AS default_customers,
    ROUND(SUM(DefaultNextMonth) * 100.0 / COUNT(*), 2)      AS default_rate_pct
FROM credit_card_clean
GROUP BY Credit_Utilization_Group
ORDER BY CASE Credit_Utilization_Group
             WHEN 'Low'        THEN 1
             WHEN 'Moderate'   THEN 2
             WHEN 'High'       THEN 3
             WHEN 'Very High'  THEN 4
             WHEN 'Over Limit' THEN 5
         END;


-- ---------------------------------------------------------------------
-- Q5. How does recent repayment status relate to default?   (Excel: PT05)
-- ---------------------------------------------------------------------
-- Business Question: Do customers with a worse latest payment status (PaymentStatus_M1) default more often?
-- Business Use: Shows whether the most recent repayment behavior is linked with default.
SELECT
    PaymentStatus_M1,
    COUNT(*)                                                AS total_customers,
    SUM(CASE WHEN DefaultNextMonth = 0 THEN 1 ELSE 0 END)   AS non_default_customers,
    SUM(CASE WHEN DefaultNextMonth = 1 THEN 1 ELSE 0 END)   AS default_customers,
    ROUND(SUM(DefaultNextMonth) * 100.0 / COUNT(*), 2)      AS default_rate_pct
FROM credit_card_clean
GROUP BY PaymentStatus_M1
ORDER BY PaymentStatus_M1;


-- ---------------------------------------------------------------------
-- Q6. How do average bill and payment differ between default and non-default customers?   (Excel: PT06)
-- ---------------------------------------------------------------------
-- Business Question: Do default customers have a different average bill and average payment?
-- Business Use: Compares billing against repayment for the two customer groups.
SELECT
    DefaultNextMonth,
    CASE WHEN DefaultNextMonth = 1 THEN 'Default' ELSE 'Non-Default' END AS customer_status,
    COUNT(*)                          AS customers,
    ROUND(AVG(Average_Bill), 2)       AS avg_bill,
    ROUND(AVG(Average_Payment), 2)    AS avg_payment
FROM credit_card_clean
GROUP BY DefaultNextMonth
ORDER BY DefaultNextMonth;


/* =====================================================================
   SECTION 5 - ADDITIONAL ANALYSIS
   ===================================================================== */

-- ---------------------------------------------------------------------
-- 5.1  Default rate by age group
-- ---------------------------------------------------------------------
-- Business Question: Does the default rate change with age group?
-- Business Use: Age_Group is a Clean_Data field, so this adds a simple customer-profile view.
-- Note: all five age groups are shown. 60+ is small (59 customers),
--       so its rate is less reliable than the others.
SELECT
    Age_Group,
    COUNT(*)                                                AS total_customers,
    SUM(CASE WHEN DefaultNextMonth = 1 THEN 1 ELSE 0 END)   AS default_customers,
    ROUND(SUM(DefaultNextMonth) * 100.0 / COUNT(*), 2)      AS default_rate_pct
FROM credit_card_clean
GROUP BY Age_Group
ORDER BY Age_Group;

/* ================================ END ================================ */






