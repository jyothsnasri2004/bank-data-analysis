# bank-data-analysis
 
 # Project Overview
This project involves analyzing a simulated banking dataset using SQL to extract customer insights, understand account distribution, and calculate key financial metrics. It covers data cleaning, customer segmentation, and financial aggregation across different types of accounts and regions.

# Tools & Technologies
- **SQL (MySQL)**
- **DBMS:** MySQL Workbench / pgAdmin
- **Version Control:** GitHub

# Database Schema

The project uses the following main tables:
- `customers` – Customer personal details
- `accounts` – Account types, balances, open dates
- `cards` – Card-related information
- `loans` – Loan details
- `transactions` – Transactional history

# Analysis
some sample code snippets
```sql
ALTER TABLE customers
CHANGE COLUMN `ï»¿CustomerID` `CustomerID` INT;

## key analysis

-- Number of customers by location
SELECT location, COUNT(*) AS count_of_customers
FROM customers
GROUP BY location
ORDER BY count_of_customers DESC;

-- Total and average balance by account type
SELECT type AS account_type, 
       SUM(balance) AS total_balance, 
       AVG(balance) AS average_balance
FROM accounts
GROUP BY type;

