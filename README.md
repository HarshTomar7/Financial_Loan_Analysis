# 🏦 Bank Loan Portfolio Risk Analysis
**SQL + Python + Power BI &nbsp;|&nbsp; Harsh Singh Tomar**

---

## The Problem

A bank gives out thousands of loans every month.

Some borrowers pay back on time. Some don't. The bank needs to know:
- Are we actually making money?
- Which borrowers are risky?
- Where are the losses coming from?

I took a dataset of **38,576 real loan records** and answered these questions using SQL, Python, and Power BI.

---

## The Data

Each row in the dataset is one loan. It tells us:
- How much was given out, and how much was paid back
- The borrower's income, credit grade, and debt-to-income ratio
- Whether the loan was fully paid, defaulted, or still ongoing
- Why they took the loan (debt consolidation, car, business, etc.)

---

## Tools & Approach

This project has three layers built on the same dataset:

| Layer | Tool | What It Does |
|---|---|---|
| SQL Analysis | PostgreSQL | 9 queries — profitability, default rate, grade risk, purpose, income, term, state |
| Python EDA | Pandas, NumPy, Matplotlib, Seaborn | Same 9 analyses rebuilt in Python + visualizations for every step |
| Dashboard | Power BI (DAX) | Interactive executive dashboard — portfolio overview and borrower risk view |

The SQL and Python analyses run independently on the same data. Landing on the same numbers in both gave me confidence the findings were correct, not a query bug.

Python adds one thing SQL doesn't do cleanly: **multi-condition income grouping using `np.select()`**, and a chart for every analysis step using Matplotlib and Seaborn.

---

## What I Did — Step by Step

### Step 1 — Is the bank profitable?
Checked the big picture first — total money given out vs total money received back.

> **Result:** $436M disbursed → $473M received → **$37M profit**

The bank is profitable. But that number hides risk underneath, which is what the next steps explore.

---

### Step 2 — How many loans went bad?
Broke down loans by status: Fully Paid, Charged Off (defaulted), or Current.

> **Result:** 83% paid back, **13.82% defaulted**, 3% ongoing

Roughly **1 in 7 loans** never got fully paid back.

---

### Step 3 — Who is defaulting?
The bank assigns credit grades A to G (A = most reliable, G = riskiest). I checked whether grade actually predicts who defaults.

| Grade | Default Rate |
|-------|-------------|
| A | 5.70% |
| B | 11.50% |
| C | 16.02% |
| D | 20.69% |
| E | 24.80% |
| F | 30.25% |
| G | 31.31% |

> **Finding:** Grade is a strong default predictor. Grade G borrowers default at **5.5x the rate** of Grade A borrowers. The pattern is clean and consistent across all 7 grades.

---

### Step 4 — Why are people borrowing?
Looked at what borrowers said they needed the money for.

> **Finding:** Debt consolidation accounts for **$232M — more than half the entire portfolio.** People are taking new loans to pay off old debts. Small business loans had the highest default rate among the top purposes.

---

### Step 5 — Does income predict repayment?
Split borrowers into Low, Middle, and High income groups (using `np.select()` in Python / `CASE WHEN` in SQL) and compared their default behaviour.

> **Surprising finding:** High-income borrowers don't default significantly less than mid-income ones. **DTI ratio** (debt load relative to income) was the better predictor — not raw income.

---

### Step 6 — Does loan length matter?
Compared 36-month vs 60-month loan terms.

> **Finding:** 60-month loans default more. The longer the repayment period, the more chances for something to go wrong in a borrower's life.

---

### Step 7 — Which states carry the most exposure?
Ranked states by total loan volume and default rate.

> **Finding:** CA, NY, and TX dominate the portfolio. Geographic concentration means a regional economic shock in any of those states directly hurts the bank's overall portfolio health.

---

## Dashboard

### Page 1 — Portfolio Overview
<img width="1306" height="728" alt="Page 1" src="https://github.com/user-attachments/assets/6056d01f-160c-4693-abc4-d9156311ab5f" />

High-level view: total disbursed, total received, profit, default rate, monthly trend, loan distribution by grade and purpose, loan status split.

### Page 2 — Borrower & Risk View
<img width="1302" height="727" alt="Page 2" src="https://github.com/user-attachments/assets/cdab52c9-a290-4b2d-9e3a-1b4aa5a498cf" />

Borrower-level view: default rate by grade, avg loan by income group, risk segment distribution, and top borrowers by repayment.

---

## What I Concluded

The bank is profitable, but the **13.82% default rate** means real money is being written off every year. The main risk factors:

1. **Low credit grade** — Grade F and G borrowers default at 30%+
2. **High DTI** — debt pressure predicts default better than income level
3. **Longer loan terms** — 60-month loans carry meaningfully more risk than 36-month ones
4. **Portfolio concentration** — debt consolidation ($232M) and a few large states dominate; concentration is a systemic risk

---

## What I'd Do Next

- Build a proper default-probability model (logistic regression, starting with grade + DTI + term as features)
- Look at whether default rates changed across months — are there seasonal patterns?
- Clean up income outliers — some values looked unrealistically high and may be skewing the income group analysis

---

## Files

```
├── loan_analysis.sql          → 9 SQL queries (PostgreSQL) — full portfolio analysis
├── Financial_Loan.py          → Same analysis in Python (Pandas, NumPy, Matplotlib, Seaborn)
├── Financial_Loan_Dashboard.pbix  → Power BI dashboard file
├── README.md                  → This file
├── Page_1.png                 → Dashboard page 1
└── Page_2.png                 → Dashboard page 2
```

---

*Personal learning project by Harsh Singh Tomar*
