-- ============================================
-- BANK LOAN ANALYSIS
-- Author : Harsh Singh Tomar
-- Tool   : PostgreSQL
-- ============================================
--
-- THE STORY:
-- A bank is giving out loans every month.
-- Some people pay back. Some don't.
-- The bank wants to know — are we making money?
-- Who is risky? Where are we losing?
--
-- I had 38,000 loan records and tried to answer that.
-- ============================================


CREATE TABLE bank_loans (
    id             INT PRIMARY KEY,
    member_id      INT,
    loan_amount    INT,
    annual_income  NUMERIC(15,2),
    loan_status    VARCHAR(50),     -- Fully Paid / Charged Off / Current
    grade          CHAR(1),         -- A = safest, G = riskiest
    purpose        VARCHAR(100),
    address_state  VARCHAR(5),
    int_rate       NUMERIC(6,4),    -- stored as decimal e.g. 0.12 = 12%
    dti            NUMERIC(6,2),    -- debt-to-income ratio
    total_payment  NUMERIC(15,2),
    term           VARCHAR(20),     -- 36 months or 60 months
    issue_date     DATE
);


-- ============================================
-- STEP 1 — Is the bank even profitable?
-- (Start with the big picture before going deeper)
-- ============================================

SELECT
    SUM(loan_amount)                              AS total_given_out,
    SUM(total_payment)                            AS total_received_back,
    SUM(total_payment) - SUM(loan_amount)         AS net_profit,
    COUNT(*)                                      AS total_loans
FROM bank_loans;

-- Result: $436M given, $473M received = $37M profit
-- The bank is making money. But from who? And at what risk?
-- That's what the next queries answer.


-- ============================================
-- STEP 2 — How many loans actually went bad?
-- ============================================

-- "Charged Off" = customer stopped paying = bank loses money
-- I needed to know how big the default problem really is.

SELECT
    loan_status,
    COUNT(*)                                            AS loans,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)  AS percentage
FROM bank_loans
GROUP BY loan_status
ORDER BY loans DESC;

-- 83% Fully Paid, 14% Charged Off, 3% Current
-- So roughly 1 in 7 loans is a loss. That's worth investigating.


-- ============================================
-- STEP 3 — What is the exact default rate?
-- ============================================

SELECT
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2) AS default_rate_pct
FROM bank_loans;

-- 13.82% — this becomes the benchmark number for everything else.
-- Any segment above 13.82% is worse than average. Below = better.


-- ============================================
-- STEP 4 — Which type of borrower defaults the most?
-- (The bank uses grades A-G to rate borrowers)
-- ============================================

-- This was my most important query.
-- If grade truly predicts risk, we should see a clear pattern.

SELECT
    grade,
    COUNT(*)                                                             AS total_loans,
    ROUND(AVG(int_rate) * 100, 2)                                       AS avg_interest_pct,
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2)                                                                   AS default_rate_pct
FROM bank_loans
GROUP BY grade
ORDER BY grade;

-- Grade A: 5.7% default | Grade G: 31.3% default
-- Clear pattern confirmed — grade is a strong risk signal.
-- The bank is also charging higher interest to riskier grades, which makes sense.


-- ============================================
-- STEP 5 — What are people borrowing money for?
-- ============================================

-- I wanted to see if certain loan purposes are riskier than others.

SELECT
    purpose,
    COUNT(*)          AS total_loans,
    SUM(loan_amount)  AS total_amount,
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2)                AS default_rate_pct
FROM bank_loans
GROUP BY purpose
ORDER BY total_amount DESC
LIMIT 10;

-- Debt consolidation = $232M, more than half the portfolio.
-- People are taking new loans to pay off old debts.
-- Small business loans had the highest default rate among top purposes.


-- ============================================
-- STEP 6 — Does income level affect repayment?
-- ============================================

SELECT
    CASE
        WHEN annual_income < 50000  THEN 'Low Income  (< $50K)'
        WHEN annual_income < 100000 THEN 'Mid Income  ($50K–$100K)'
        ELSE                             'High Income (> $100K)'
    END                             AS income_group,
    COUNT(*)                        AS borrowers,
    ROUND(AVG(loan_amount), 0)      AS avg_loan,
    ROUND(AVG(dti), 2)              AS avg_dti,
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2)                              AS default_rate_pct
FROM bank_loans
GROUP BY income_group
ORDER BY avg_loan DESC;

-- Surprising finding: high income borrowers don't default much less.
-- DTI (debt pressure) matters more than raw income.


-- ============================================
-- STEP 7 — Does loan length affect defaults?
-- ============================================

SELECT
    term,
    COUNT(*)                                                             AS total_loans,
    ROUND(AVG(int_rate) * 100, 2)                                       AS avg_interest_pct,
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2)                                                                   AS default_rate_pct
FROM bank_loans
GROUP BY term;

-- 60-month loans default more than 36-month loans.
-- Longer the loan, more chances for life to go wrong.


-- ============================================
-- STEP 8 — Which states are highest risk?
-- ============================================

SELECT
    address_state,
    COUNT(*)          AS total_loans,
    SUM(loan_amount)  AS total_disbursed,
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2)                AS default_rate_pct
FROM bank_loans
GROUP BY address_state
ORDER BY total_disbursed DESC
LIMIT 10;


-- ============================================
-- STEP 9 — Final summary: how healthy is the portfolio?
-- ============================================

SELECT
    COUNT(*)                                                              AS total_loans,
    ROUND(SUM(loan_amount) / 1000000.0, 2)                               AS disbursed_millions,
    ROUND(SUM(total_payment) / 1000000.0, 2)                             AS received_millions,
    ROUND((SUM(total_payment) - SUM(loan_amount)) / 1000000.0, 2)        AS profit_millions,
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2)                AS repayment_rate_pct,
    ROUND(
        COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*),
    2)                                                                    AS default_rate_pct
FROM bank_loans;

-- Repayment rate > 100% because interest is included in payments.
-- Portfolio is healthy overall, but the 13.82% default rate
-- means the bank is still writing off millions every year.


-- ============================================
-- END
-- ============================================
