

-- =========================================
-- FINANCIAL LOAN ANALYTICS PROJECT
-- =========================================
-- Tool: PostgreSQL
-- Dataset: Financial Loan Dataset
-- Author: Harsh Singh Tomar
--
-- Objective:
-- Perform advanced financial analysis to understand
-- credit risk, customer behavior, loan performance,
-- and profitability of the loan portfolio.
-- =========================================



-- Database Creation
create database bankloan

-- Table Creation

CREATE TABLE financial_loan (
    id INT PRIMARY KEY,
    address_state VARCHAR(5),
    application_type VARCHAR(50),
    emp_length VARCHAR(20),
    emp_title VARCHAR(255),
    grade CHAR(1),
    home_ownership VARCHAR(20),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id INT,
    purpose VARCHAR(100),
    sub_grade CHAR(2),
    term VARCHAR(20),
    verification_status VARCHAR(50),
    annual_income NUMERIC(15,2),
    dti NUMERIC(10,4),
    installment NUMERIC(10,2),
    int_rate NUMERIC(10,4),
    loan_amount INT,
    total_acc INT,
    total_payment NUMERIC(15,2)
);

-- =========================
-- SECTION A: CORE PORTFOLIO KPIs
-- BUSINESS QUESTION:
-- What is the overall performance of the loan portfolio?
-- =========================

SELECT
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_received,
    COUNT(DISTINCT member_id) AS total_borrowers,
    ROUND(SUM(total_payment) - SUM(loan_amount), 2) AS profit
FROM financial_loan;


-- =========================
-- SECTION B: LOAN STATUS ANALYSIS (RISK VIEW)
-- BUSINESS QUESTION:
-- How are loans distributed across different statuses?
-- =========================

SELECT
    loan_status,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_amount,
    SUM(total_payment) AS total_received
FROM financial_loan
GROUP BY loan_status
ORDER BY total_amount DESC;


-- =========================
-- SECTION C: DEFAULT RATE
-- BUSINESS QUESTION:
-- What percentage of loans are defaulting?
-- =========================

SELECT
    COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*) 
    AS default_rate
FROM financial_loan;


-- =========================
-- SECTION D: CUSTOMER LIFETIME VALUE (CLV PROXY)
-- BUSINESS QUESTION:
-- Which customers generate the most value?
-- =========================

SELECT
    member_id,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_borrowed,
    SUM(total_payment) AS total_paid,
    AVG(int_rate) AS avg_interest
FROM financial_loan
GROUP BY member_id
ORDER BY total_paid DESC;


-- =========================
-- SECTION E: RISK SEGMENTATION
-- BUSINESS QUESTION:
-- How can borrowers be segmented based on credit risk?
-- =========================

SELECT *,
CASE
    WHEN dti > 20 AND int_rate > 15 THEN 'High Risk'
    WHEN dti BETWEEN 10 AND 20 THEN 'Medium Risk'
    ELSE 'Low Risk'
END AS risk_segment
FROM financial_loan;


-- =========================
-- SECTION F: GRADE ANALYSIS (CREDIT QUALITY)
-- BUSINESS QUESTION:
-- How does credit grade impact loan performance?
-- =========================

SELECT
    grade,
    COUNT(*) AS loans,
    AVG(int_rate) AS avg_interest,
    SUM(loan_amount) AS total_amount
FROM financial_loan
GROUP BY grade
ORDER BY grade;


-- =========================
-- SECTION G: PURPOSE ANALYSIS
-- BUSINESS QUESTION:
-- Why do customers take loans and which purposes dominate?
-- =========================

SELECT
    purpose,
    COUNT(*) AS applications,
    SUM(loan_amount) AS total_amount,
    AVG(int_rate) AS avg_rate
FROM financial_loan
GROUP BY purpose
ORDER BY total_amount DESC;


-- =========================
-- SECTION H: INCOME VS LOAN BEHAVIOR
-- BUSINESS QUESTION:
-- How does income level affect borrowing behavior?
-- =========================

SELECT
    CASE
        WHEN annual_income < 50000 THEN 'Low Income'
        WHEN annual_income < 100000 THEN 'Mid Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS borrowers,
    AVG(loan_amount) AS avg_loan,
    AVG(dti) AS avg_dti
FROM financial_loan
GROUP BY income_group;


-- =========================
-- SECTION I: STATE-LEVEL RISK ANALYSIS
-- BUSINESS QUESTION:
-- Which regions contribute most to loan volume and risk?
-- =========================

SELECT
    address_state,
    COUNT(*) AS loans,
    SUM(loan_amount) AS total_amount,
    AVG(dti) AS avg_dti
FROM financial_loan
GROUP BY address_state
ORDER BY total_amount DESC;


-- =========================
-- SECTION J: REPAYMENT EFFICIENCY
-- BUSINESS QUESTION:
-- How efficiently are loans being repaid?
-- =========================

SELECT
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2) AS repayment_rate
FROM financial_loan;


-- =========================================
-- INSIGHTS
-- =========================================

-- 1. PORTFOLIO PERFORMANCE
-- The loan portfolio is overall profitable with repayments exceeding disbursements.
-- Despite this, a noticeable portion of loans is still being written off.


-- 2. CUSTOMER DISTRIBUTION
-- Revenue is concentrated among a small group of borrowers.
-- Majority of customers contribute relatively smaller amounts individually.


-- 3. RISK LABELING ISSUE
-- Customers marked as “Low Risk” are still appearing in charged-off cases.
-- Indicates inconsistency between risk labels and actual outcomes.


-- 4. CREDIT QUALITY PATTERN
-- Higher-grade loans show stable and predictable repayment.
-- Lower-grade loans show more volatility in repayment behavior.


-- 5. FINANCIAL PRESSURE INDICATORS
-- Borrowers with higher DTI ratios show weaker repayment patterns.
-- Income alone does not fully explain default behavior.


-- 6. LOAN PURPOSE BEHAVIOR
-- Debt consolidation is the most common borrowing reason.
-- Loan usage patterns vary significantly across purposes.


-- 7. REGIONAL EXPOSURE
-- Loan distribution is heavily skewed toward a few key states.
-- Smaller regions contribute very little to overall volume.


-- 8. REPAYMENT TRENDS
-- A large portion of loans are successfully completed.
-- However, early defaults are visible in some customer segments.




-- =========================
-- END OF PROJECT
-- =========================