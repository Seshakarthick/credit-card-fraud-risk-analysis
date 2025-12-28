create database sql_risk_analysis_queries;

show databases;

use sql_risk_analysis_queries;

SELECT COUNT(time) FROM creditcard;

SELECT * FROM creditcard;

drop table creditcard;



-- creating a table to insert a data

CREATE TABLE credit_card_data (
    Time INT,
    V1 FLOAT,
    V2 FLOAT,
    V3 FLOAT,
    V4 FLOAT,
    V5 FLOAT,
    V6 FLOAT,
    V7 FLOAT,
    V8 FLOAT,
    V9 FLOAT,
    V10 FLOAT,
    V11 FLOAT,
    V12 FLOAT,
    V13 FLOAT,
    V14 FLOAT,
    V15 FLOAT,
    V16 FLOAT,
    V17 FLOAT,
    V18 FLOAT,
    V19 FLOAT,
    V20 FLOAT,
    V21 FLOAT,
    V22 FLOAT,
    V23 FLOAT,
    V24 FLOAT,
    V25 FLOAT,
    V26 FLOAT,
    V27 FLOAT,
    V28 FLOAT,
    Amount FLOAT,
    Class INT
);



-- It tells you the exact folder path where MySQL permits

SHOW VARIABLES LIKE 'secure_file_priv';

-- to import data into a table

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/creditcard.csv'
INTO TABLE credit_card_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;




-- to check all data are imported 

SHOW TABLES;

SELECT COUNT(*) FROM credit_card_data;

SELECT * FROM credit_card_data
LIMIT 5;

USE sql_risk_analysis_queries;



-- Objective: Understand dataset size (Total Records in Dataset)
SELECT COUNT(*) AS total_transactions
FROM credit_card_data;
 


 -- Objective: Understand imbalance in fraud data (Check Fraud vs Non-Fraud Distribution)
SELECT 
    Class,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_card_data), 2) AS percentage
FROM credit_card_data
GROUP BY Class;



-- Objective: Identify missing or invalid values (DATA QUALITY CHECK)
SELECT
    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS missing_time,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS missing_amount,
    SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS missing_class
FROM credit_card_data;



-- Objective: Understand transaction behavior (TRANSACTION AMOUNT DISTRIBUTION)
SELECT
    ROUND(AVG(Amount),2) AS avg_amount,
    ROUND(MIN(Amount),2) AS min_amount,
    ROUND(MAX(Amount),2) AS max_amount,
    ROUND(STDDEV(Amount),2) AS std_deviation
FROM credit_card_data;



-- Objective: Compare behavior of fraudulent vs normal transactions (FRAUD VS NON-FRAUD COMPARISON)
SELECT
    Class,
    COUNT(*) AS txn_count,
    ROUND(AVG(Amount),2) AS avg_amount,
    ROUND(MAX(Amount),2) AS max_amount
FROM credit_card_data
GROUP BY Class;



-- Objective: Identify unusually large transactions (HIGH-VALUE TRANSACTION RISK IDENTIFICATION)
SELECT *
FROM credit_card_data
WHERE Amount >
      (SELECT AVG(Amount) + 3 * STDDEV(Amount) FROM credit_card_data);




-- Objective: Identify high-risk time windows(TIME-BASED FRAUD ANALYSIS)
SELECT
    FLOOR(Time / 3600) AS hour_bucket,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_txn,
    ROUND(SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM credit_card_data
GROUP BY hour_bucket
ORDER BY fraud_rate DESC;



-- Objective: Segment transactions based on risk exposure (RISK SEGMENTATION (BUSINESS VIEW))
SELECT
    CASE
        WHEN Amount >= 2000 THEN 'High Risk'
        WHEN Amount BETWEEN 500 AND 1999 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,
    COUNT(*) AS total_txns,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_card_data), 2) AS percentage
FROM credit_card_data
GROUP BY risk_segment;



-- Objective: Identify which risk segment contributes most to fraud (FRAUD RATE BY RISK SEGMENT)
SELECT
    risk_segment,
    COUNT(*) AS total_txn,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_cases,
    ROUND(SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM (
    SELECT *,
           CASE
               WHEN Amount >= 2000 THEN 'High Risk'
               WHEN Amount BETWEEN 500 AND 1999 THEN 'Medium Risk'
               ELSE 'Low Risk'
           END AS risk_segment
    FROM credit_card_data
) t
GROUP BY risk_segment;



-- Objective: Identify statistically abnormal transactions (ANOMALY DETECTION USING STATISTICAL DEVIATION)
SELECT
    *,
    ROUND(
        (V1 + V2 + V3 + V4 -
         (SELECT AVG(V1 + V2 + V3 + V4) FROM credit_card_data))
        /
        (SELECT STDDEV(V1 + V2 + V3 + V4) FROM credit_card_data),
    2) AS anomaly_score
FROM credit_card_data;



-- Objective: Identify highest-risk transactions (TOP SUSPICIOUS TRANSACTIONS)
SELECT 
    *
FROM
    (SELECT 
        *,
            ABS((V1 + V2 + V3) - (SELECT 
                    AVG(V1 + V2 + V3)
                FROM
                    credit_card_data)) AS risk_score
    FROM
        credit_card_data) t
ORDER BY risk_score DESC
LIMIT 10;