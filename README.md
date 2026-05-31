# 🏦 Bank Loan Analysis
**SQL + Power BI &nbsp;|&nbsp; Harsh Singh Tomar**

---

## The Problem

A bank gives out thousands of loans every month.

Some borrowers pay back on time. Some don't. The bank needs to know:
- Are we actually making money?
- Which borrowers are risky?
- Where are the losses coming from?

I took a dataset of **38,000+ real loan records** and tried to answer these questions using SQL and Power BI.

---

## The Data

Each row in the dataset is one loan. It tells us:
- How much was given, and how much was paid back
- The borrower's income, job, and credit grade
- Whether the loan was fully paid, defaulted, or still ongoing
- Why they took the loan (debt consolidation, car, business, etc.)

---

## What I Did — Step by Step

### Step 1 — Is the bank profitable?
The first thing I checked was the big picture. Total money given out vs total money received.

> **Result:** $436M disbursed → $473M received → **$37M profit**

The bank is profitable. But that profit hides some risk underneath, which is what I explored next.

---

### Step 2 — How many loans went bad?
I broke down loans by status: Fully Paid, Charged Off (defaulted), or Current.

> **Result:** 83% paid back, **13.82% defaulted**, 3% ongoing

So roughly **1 in 7 loans** never got fully paid back. That's a real problem.

---

### Step 3 — Who is defaulting?
The bank assigns credit grades A to G (A = most reliable, G = riskiest). I checked whether this grade actually predicts who defaults.

| Grade | Default Rate |
|-------|-------------|
| A | 5.7% |
| B | 11.5% |
| C | 16.0% |
| D | 20.7% |
| E | 24.8% |
| F | 30.3% |
| G | 31.3% |

> **Finding:** The grade system works — there's a clear pattern from safe to risky. Grade G borrowers default at **5x the rate** of Grade A borrowers.

---

### Step 4 — Why are people borrowing?
I looked at what borrowers said they needed the money for.

> **Finding:** Debt consolidation alone accounts for **$232M — more than half the portfolio.** People are taking new loans to pay off old debts. Small business loans had the highest default rate.

---

### Step 5 — Does income predict repayment?
I split borrowers into low, mid, and high income groups and compared their behaviour.

> **Surprising finding:** High-income borrowers don't default significantly less. The **DTI ratio** (how much debt they already have vs their income) was a better predictor than income alone.

---

### Step 6 — Does loan length matter?
I compared 36-month vs 60-month loans.

> **Finding:** 60-month loans default more. The longer the repayment period, the more chances for something to go wrong in the borrower's life.

---

## Dashboard

### Page 1 — Portfolio Overview
![Page 1](Page_1.png)

A high-level view of the whole portfolio — total numbers, monthly trends, default rate, and loan breakdown by grade and purpose.

### Page 2 — Borrower & Risk View
![Page 2](Page_2.png)

Focuses on who the borrowers are — income groups, risk segments, and how default rates vary across credit grades.

---

## What I Concluded

The bank is profitable, but the 13.82% default rate means **millions of dollars are being written off every year.** The main risk factors are:

1. **Low credit grade** — Grade F and G borrowers default at 30%+
2. **High DTI** — borrowers already stretched thin are more likely to default
3. **Longer loan terms** — 60-month loans carry more risk than 36-month ones
4. **Geographic concentration** — most loans are in a few states; if those economies suffer, the bank suffers

---

## What I'd Do Next

If I had more time, I'd:
- Build a simple scorecard to predict default probability before a loan is approved
- Look at whether default rates changed over the months (seasonal trends)
- Clean up income outliers — some values looked unrealistically high

---

## Tools

| Tool | Used For |
|---|---|
| PostgreSQL | All data analysis and querying |
| Power BI | Dashboard and visualisations |
| DAX | KPI calculations (default rate, repayment rate) |

---

## Files

```
├── loan_analysis.sql   → 9 queries that walk through the full analysis
├── README.md           → This file
├── Page_1.png          → Dashboard page 1
└── Page_2.png          → Dashboard page 2
```

---

*Personal learning project by Harsh Singh Tomar*
