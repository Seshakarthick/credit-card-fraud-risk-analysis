# 📊 Credit Card Fraud Risk Analysis

## 📌 Project Overview
This project focuses on analyzing credit card transaction data to identify fraudulent activities and assess transaction risk using **SQL** and **Power BI**.

The objective is to understand fraud behavior, detect high-risk patterns, and support data-driven decision making.

---

## 📂 Dataset Overview

- **Total Transactions:** 284,807  
- **Fraud Transactions:** 492  
- **Fraud Rate:** ~0.17%  
- **Data Type:** Real-world anonymized credit card transactions  

Each record includes:
- Transaction time  
- Transaction amount  
- Anonymized features (V1–V28)  
- Fraud label (0 = Legit, 1 = Fraud)

---

## 🛠 Tools & Technologies Used

- **SQL (MySQL)** – Data cleaning, transformation & analysis  
- **Power BI** – Dashboard creation and visualization  
- **Excel** – Raw data handling  
- **GitHub** – Version control & project sharing  

---

## 🔍 Analysis Performed

### 1️⃣ Data Cleaning & Validation
- Checked for missing values  
- Verified transaction counts  
- Validated data consistency  

### 2️⃣ Exploratory Data Analysis (EDA)
- Fraud vs legitimate transaction comparison  
- Transaction amount distribution  
- Statistical analysis of spending behavior  

### 3️⃣ Risk Segmentation
Transactions categorized based on amount:

| Risk Level | Amount Range |
|-----------|--------------|
| High Risk | ≥ 2000 |
| Medium Risk | 500 – 1999 |
| Low Risk | < 500 |

### 4️⃣ Fraud Detection Insights
- Fraud cases are rare but financially impactful  
- Higher transaction values show higher fraud probability  
- Risk segmentation improves monitoring and prevention  

---

## 📊 Power BI Dashboard Highlights

- Total transactions & fraud count  
- Fraud percentage visualization  
- Risk category distribution  
- Time-based fraud trend analysis  

---

## 📁 Project Structure

