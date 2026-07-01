# ==========================================================
# LOAN ANALYSIS PROJECT USING PYTHON
# Libraries Used: Pandas, NumPy, Matplotlib, Seaborn
# ==========================================================

# -----------------------------
# Import Libraries
# -----------------------------

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Plot Settings
sns.set_style("whitegrid")
plt.rcParams["figure.figsize"] = (8, 5)

# -----------------------------
# Load Dataset
# -----------------------------

df = pd.read_csv("Financial_Loan.csv")

# View Dataset
print(df.head())

# Dataset Information
print(df.info())

# Check Missing Values
print(df.isnull().sum())


# ==========================================================
# 1. Bank Profitability Analysis
# ==========================================================

total_given = df["Loan_Amount"].sum()

total_received = df["Total_Payment"].sum()

net_profit = total_received - total_given

total_loans = len(df)

print("Total Loans :", total_loans)
print("Total Loan Amount :", total_given)
print("Total Payment Received :", total_received)
print("Net Profit :", net_profit)


# ==========================================================
# 2. Loan Status Distribution
# ==========================================================

loan_status = df["Loan_Status"].value_counts()

loan_percentage = (
    df["Loan_Status"]
    .value_counts(normalize=True)
    * 100
).round(2)

status_df = pd.DataFrame({
    "Total Loans": loan_status,
    "Percentage": loan_percentage
})

print(status_df)

# Visualization

sns.countplot(data=df, x="Loan_Status")

plt.title("Loan Status Distribution")
plt.xlabel("Loan Status")
plt.ylabel("Number of Loans")

plt.show()


# ==========================================================
# 3. Overall Default Rate
# ==========================================================

default_rate = (
    (df["Loan_Status"] == "Charged Off").mean()
    * 100
)

print(f"Overall Default Rate : {default_rate:.2f}%")


# ==========================================================
# 4. Grade Wise Analysis
# ==========================================================

grade_analysis = (
    df.groupby("Grade")
    .agg(
        Total_Loans=("Grade", "count"),
        Average_Interest=("Int_Rate", "mean"),
        Default_Rate=(
            "Loan_Status",
            lambda x: (x == "Charged Off").mean() * 100
        )
    )
    .round(2)
)

print(grade_analysis)

# Visualization

grade_analysis["Default_Rate"].plot(kind="bar")

plt.title("Default Rate by Grade")
plt.xlabel("Grade")
plt.ylabel("Default Rate (%)")

plt.show()


# ==========================================================
# 5. Loan Purpose Analysis
# ==========================================================

purpose_analysis = (
    df.groupby("Purpose")
    .agg(
        Total_Loans=("Purpose", "count"),
        Total_Amount=("Loan_Amount", "sum"),
        Default_Rate=(
            "Loan_Status",
            lambda x: (x == "Charged Off").mean() * 100
        )
    )
    .sort_values("Total_Amount", ascending=False)
    .round(2)
)

print(purpose_analysis)

# Top 10 Loan Purposes

top_purpose = purpose_analysis.head(10)

top_purpose["Total_Amount"].plot(kind="bar")

plt.title("Top Loan Purposes")
plt.xlabel("Purpose")
plt.ylabel("Loan Amount")

plt.show()


# ==========================================================
# 6. Income Group Analysis
# ==========================================================

conditions = [

    df["Annual_Income"] < 50000,

    (df["Annual_Income"] >= 50000)
    &
    (df["Annual_Income"] < 100000),

    df["Annual_Income"] >= 100000

]

choices = [

    "Low Income",
    "Middle Income",
    "High Income"

]

df["income_group"] = np.select(
    conditions,
    choices,
    default="Unknown"
)

income_analysis = (

    df.groupby("income_group")
    .agg(

        Borrowers=("income_group", "count"),

        Average_Loan=("Loan_Amount", "mean"),

        Average_DTI=("Dti", "mean"),

        Default_Rate=(
            "Loan_Status",
            lambda x: (x == "Charged Off").mean() * 100
        )

    )

    .round(2)

)

print(income_analysis)


# ==========================================================
# 7. Loan Term Analysis
# ==========================================================

term_analysis = (

    df.groupby("Term")

    .agg(

        Total_Loans=("Term", "count"),

        Average_Interest=("Int_Rate", "mean"),

        Default_Rate=(
            "Loan_Status",
            lambda x: (x == "Charged Off").mean() * 100
        )

    )

    .round(2)

)

print(term_analysis)

# Visualization

term_analysis["Default_Rate"].plot(kind="bar")

plt.title("Default Rate by Loan Term")
plt.xlabel("Loan Term")
plt.ylabel("Default Rate (%)")

plt.show()


# ==========================================================
# 8. State Wise Loan Analysis
# ==========================================================

state_analysis = (

    df.groupby("Address_State")

    .agg(

        Total_Loans=("Address_State", "count"),

        Total_Disbursed=("Loan_Amount", "sum"),

        Default_Rate=(
            "Loan_Status",
            lambda x: (x == "Charged Off").mean() * 100
        )

    )

    .sort_values("Total_Disbursed", ascending=False)

    .head(10)

    .round(2)

)

print(state_analysis)

# Visualization

state_analysis["Total_Disbursed"].plot(kind="bar")

plt.title("Top 10 States by Loan Amount")
plt.xlabel("State")
plt.ylabel("Loan Amount")

plt.show()


# ==========================================================
# 9. Portfolio Summary
# ==========================================================

portfolio_summary = pd.DataFrame({

    "Metric": [

        "Total Loans",
        "Total Loan Amount",
        "Total Payment Received",
        "Net Profit",
        "Repayment Rate (%)",
        "Default Rate (%)"

    ],

    "Value": [

        len(df),

        round(df["Loan_Amount"].sum(), 2),

        round(df["Total_Payment"].sum(), 2),

        round(
            df["Total_Payment"].sum()
            - df["Loan_Amount"].sum(),
            2
        ),

        round(
            (
                df["Total_Payment"].sum()
                /
                df["Loan_Amount"].sum()
            ) * 100,
            2
        ),

        round(
            (
                df["Loan_Status"] == "Charged Off"
            ).mean() * 100,
            2
        )

    ]

})

print(portfolio_summary)