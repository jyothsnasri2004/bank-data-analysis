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
- 
# Data Cleaning
Resolved column encoding issues caused by import errors:
```sql
ALTER TABLE customers
CHANGE COLUMN `ï»¿CustomerID` `CustomerID` INT;
