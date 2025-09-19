# SQL-Based Financial Customer Analysis

This repository contains a comprehensive SQL analysis of a simulated banking database. The project aims to derive actionable insights into customer demographics, financial health, and product engagement by querying a relational database consisting of customer, account, card, loan, and transaction data.

## Project Goal

The primary objective of this project is to answer key business questions using SQL. This involves:

  * Performing customer segmentation based on various attributes.
  * Analyzing the performance and distribution of financial products (accounts, cards, loans).
  * Assessing the overall financial health and transaction patterns of customers.
  * Demonstrating proficiency in a range of SQL techniques, from basic aggregations to advanced joins, subqueries, and conditional logic.

## Database Schema

The analysis was performed on a relational database with the following inferred schema:

  * **`customers`**

      * `CustomerID` (Primary Key)
      * `Name`
      * `DOB`
      * `Location`

  * **`accounts`**

      * `AccountID` (Primary Key)
      * `CustomerID` (Foreign Key to `customers`)
      * `Type` (e.g., 'Savings', 'Fixed Deposit')
      * `Balance`
      * `OpenDate`

  * **`cards`**

      * `CardID` (Primary Key)
      * `CustomerID` (Foreign Key to `customers`)
      * `Type` (e.g., 'Debit', 'Credit')
      * `Status` (e.g., 'Active', 'Blocked')
      * `IssueDate`

  * **`loans`**

      * `LoanID` (Primary Key)
      * `CustomerID` (Foreign Key to `customers`)
      * `Type` (e.g., 'Home Loan', 'Personal Loan')
      * `Amount`
      * `Status` (e.g., 'Approved', 'Pending')
      * `StartDate`

  * **`transactions`**

      * `TransactionID` (Primary Key)
      * `AccountID` (Foreign Key to `accounts`)
      * `Type` (e.g., 'Credit', 'Debit')
      * `Amount`
      * `Date`

## Key Questions and Findings

The SQL script `bank-analysis.sql` contains over 50 queries designed to uncover insights. Below are some of the key findings:

### 1\. Customer Segmentation & Demographics

  * **Geographical Distribution:** Identified the top locations with the highest concentration of customers, which can be used to inform regional marketing strategies.
  * **Multi-Product Customers:** Queried for customers who hold multiple types of accounts, cards, and loans, identifying them as highly engaged and valuable clients.

### 2\. Financial Health & Risk Assessment

  * **Net Financial Position:** A key analysis was performed to calculate each customer's net financial health by subtracting their total loan amounts from their total account balances.
    ```sql
    /* Query to find customers with a negative financial balance */
    SELECT
        c.name,
        c.customerid,
        SUM(a.balance) AS total_balance,
        SUM(l.amount) AS total_loan_amount,
        (SUM(a.balance) - SUM(l.amount)) AS financial_balance
    FROM customers c
    JOIN accounts a ON c.customerid = a.customerid
    JOIN loans l ON c.customerid = l.customerid
    GROUP BY c.customerid, c.name
    HAVING financial_balance < 0;
    ```
  * **High-Risk Identification:** The query above successfully flagged customers whose liabilities (loans) outweigh their assets (balances), representing a potential credit risk to the bank.

### 3\. Product & Transaction Analysis

  * **Account & Loan Popularity:** Determined the total balance held in each account type and the total loan amount disbursed for each loan type, revealing the most popular products.
  * **Card Usage Patterns:** Analyzed the distribution of card types (Credit, Debit, Prepaid) and their statuses (Active, Inactive, Blocked). The analysis also identified the peak year for card issuance.
  * **Transaction Behavior:** Aggregated transaction data to profile customers based on their credit and debit activity, including the total amount transacted and the frequency of transactions.
    ```sql
    /* Query to get a full credit/debit profile for each customer */
    SELECT
        c.name,
        c.customerid,
        COUNT(t.transactionid) AS number_of_transactions,
        SUM(CASE WHEN t.type = 'credit' THEN 1 ELSE 0 END) AS credit_count,
        SUM(CASE WHEN t.type = 'credit' THEN t.amount ELSE 0 END) AS total_credit_amount,
        SUM(CASE WHEN t.type = 'debit' THEN 1 ELSE 0 END) AS debit_count,
        SUM(CASE WHEN t.type = 'debit' THEN t.amount ELSE 0 END) AS total_debit_amount
    FROM transactions t
    JOIN accounts a ON a.AccountID = t.accountid
    JOIN customers c ON c.customerid = a.customerid
    GROUP BY c.customerid, c.name
    ORDER BY number_of_transactions DESC;
    ```
  * **Inactive Customers:** Identified customers who hold active loan or card products but have no corresponding transaction history in their accounts, suggesting potential churn or dormancy.

## Technologies Used

  * **Language:** SQL (MySQL dialect)
  * **Tool:** MySQL Workbench
