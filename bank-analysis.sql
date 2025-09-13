create database finance_data;

select * from customers;
select *from accounts;
select * from cards;
select * from loans;
select * from transactions;

ALTER TABLE customers
CHANGE COLUMN `ï»¿CustomerID` `CustomerID` INT;

alter table accounts
change column `ï»¿AccountID` `accountID` int;

alter table cards
change column `ï»¿CardID` `cardid` int;

alter table loans
change column `ï»¿LoanID` `loanid` int;
select* from loans;

alter table transactions
change column `ï»¿TransactionID` `transactionid` int;

/*no.of customer in diff locations*/
select location, count(*) as count_of_customers from customers
group by location
order by count_of_customers desc;

/*grouping people by age group*/
select dob, count(*) as same_age from customers
group by dob order by same_age desc;

/*no.of customers with particular type of account*/
select a.type, count(*) from accounts a
group by a.type;


select c.customerid, c.name, c.location, a.accountid, a.type
from customers c, accounts a 
where c.customerid = a.CustomerID and a.type = "fixed deposit";

/*displaying the account details of a particular customer*/
select c.customerid, c.name,a.type,a.opendate,a.balance
from customers c , accounts a
where c.CustomerID = a.CustomerID and c.CustomerID = 2;

/*finding the average and total balance in different types of accounts*/
select type as account_type, sum(balance) as total_balance, avg(balance) as average_balance
from accounts group by type;

/*finding the total balance of the customers different types of accounts*/
SELECT c.customerid,c.name,a.type AS account_type,SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customerid = a.customerid
GROUP BY c.customerid, c.name, a.type
order by total_balance desc;

/*finding a customer with total no.of different types of accs along with the total amount*/
select customerid, type,sum(balance) as total_amount, count(type) as total_acc
from accounts 
group by customerid,type having  total_acc > 1;

/*find the total amount in the customers accounts*/
SELECT c.customerid, c.name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customerid = a.customerid
GROUP BY c.customerid, c.name order by total_balance desc;


/*finding the customers with total no.of accounts and the total amount in them*/
select customerid, count(accountid) as no_of_accounts, sum(balance) as total_amount
from accounts group by customerid having no_of_accounts > 1 order by total_amount desc;

/*finding customer with ony fixed deposit accounts*/
select c.customerid,a.accountid,c.name,a.type,c.location, a.opendate, a.balance
from customers c, accounts a
where c.CustomerID = a.CustomerID and a.type = "fixed deposit";

/*total no.of depit and credit cards of a customer*/
select c.customerid,c.name,count(ca.type) as no_of_cards
from customers c join cards ca
on c.customerid = ca.customerid
group by c.customerid, c.name order by no_of_cards desc;

/*total no.of cards of each category*/
select ca.type, count(ca.type) as total_count from cards ca
group by ca.type;

/*finding the no.of credit or debit cards a customer has*/
select c.customerid,c.name, ca.type, count(ca.type) as no_of_cards
from customers c 
join cards ca on c.customerid = ca.customerid
group by c.customerid,c.name,ca.type;

/*how many active or blocked or inactive cards are there according to type of cards*/
select ca.type, ca.status,count(ca.status) as status_of_the_card from cards ca 
group by ca.type, ca.status having ca.type = "debit";

/*how many customers have both debit card and credit card*/
select c.customerid, c.name,
sum(ca.type = "credit") as credit_card_count, sum(ca.type = "debit") as debit_count
from customers c join cards ca on c.CustomerID = ca.CustomerID
group by c.customerid, c.name
having credit_card_count > 0 and debit_count >0;

/*find no.of cards(credit and debit) each customer has*/
select c.customerid, c.name, 
sum(case when ca.type ='credit' then 1 else 0 end) as credit_count,
sum(case when ca.type='debit' then 1 else 0 end) as debit_count,
sum(case when ca.type = 'prepaid' then 1 else 0 end) as card_count
from customers c join cards ca on c.customerid = ca.customerid
group by c.customerid, c.name;

/*in which year more no.of cards are issued*/
select year(ca.issuedate) as issued_year, count(*) as no_of_cards_issued from cards ca
group by year(ca.issuedate) order by no_of_cards_issued desc;

/*filtering customers on their card status based*/
select c.customerid, c.name, ca.status,ca.type
from customers c join cards ca on c.CustomerID = ca.CustomerID
group by c.customerid,c.name,ca.status,ca.type having ca.status = "active" ;

/*no.of cards active or blocked or inactive*/
select ca.status, ca.type,count(ca.status) as total_count from cards ca
group by ca.status, ca.type;

/*finding the no.of cards each customers has and the type of cards they have*/
select c.customerid, c.name,
sum(ca.type = "credit") as credit,sum(ca.type = "debit") as debit, 
sum(ca.type = "prepaid") as prepaid, count(ca.cardid) as total
from customers c join cards ca on ca.CustomerID = c.CustomerID
group by c.customerid, c.name having total = 3;

/*loan*/
/*total amount per loan type*/
select l.type, sum(l.amount) as total_amount 
from loans l
group by l.type;

/*no.of loans in each category*/
select l.status, count(l.loanid) as no_of_loans
from loans l 
group by l.status;

/*customer and the type of loan they took*/
select c.customerid, c.name,l.loanid, l.type from customers c
join loans l on l.CustomerID = c.CustomerID
where l.type = "personal loan";

/*customers with highest loan amount per loan type*/
select c.customerid, c.name, l.type,max(l.amount) as max_amount
from customers c join loans l on c.customerid = l.customerid
group by c.CustomerID,c.name,l.type;

/*finding the customers with maximum loan amount of diffferent loan types*/
select c.customerid,c.name,l.type,l.amount
from loans l join customers c on c.customerid = l.customerid
where (l.type , l.amount) in (select type, max(amount) as amount
from loans  group by type);

/*customer with highest total loan amount*/
select c.customerid,c.name,sum(l.amount) as total_amount
from loans l join customers c on c.customerid = l.CustomerID
group by c.customerid, c.name order by total_amount desc limit 1;

/*no.of loans a customer has*/
select c.customerid, c.name, count(l.loanid) as no_of_loans
from loans l join customers c on l.customerid = c.customerid
group by c.customerid, c.name order by no_of_loans desc limit 5;

/*total loan amount and their loan break-up*/
select c.customerid, c.name, sum(l.amount) as amount, count(l.loanid) as no_of_loans,
sum(case when l.type = "car loan" then 1 else 0 end) as car_loan,
sum(case when l.type = "education loan" then 1 else 0 end) as edu_loan,
sum(case when l.type = "personal loan" then 1 else 0 end) as personal_loan,
sum(case when l.type = "home loan" then 1 else 0 end) as home_loan
from loans l join customers c on c.customerid = l.customerid
group by c.customerid,c.name;

select l.type,l.loanid,l.startdate,c.CustomerID,l.customerid,c.name
from loans l join customers c on c.customerid = l.CustomerID;

select c.customerid,c.name,l.loanid,l.type,l.startdate
from loans l join customers c on c.customerid = l.customerid
where l.startdate >= "2019-01-01";

describe loans;

SELECT c.customerid,c.name,l.loanid,l.type,l.startdate
FROM loans l JOIN customers c ON c.customerid = l.customerid
WHERE STR_TO_DATE(l.startdate, '%d-%m-%Y') >= '2025-01-01';

/*loan status of each customer*/
select c.customerid,c.name,count(l.loanid) as no_of_loans,sum(case when l.status = "approved" then 1 else 0 end) as approved,
sum(case when l.status = "rejected" then 1 else 0 end) as rejected,
sum(case when l.status = "pending" then 1 else 0 end) as pending,
sum(case when l.status = "closed" then 1 else 0 end) as closed
from loans l join customers c on c.customerid = l.customerid
group by c.customerid,c.name;

select c.customerid,c.name,l.loanid,l.status
from loans l join customers c on l.customerid = c.CustomerID
where l.status = "approved" or l.status = "closed" ;

/*transactions*/
select c.customerid,c.name,t.transactionid, t.amount, t.type,t.date
from transactions t 
join accounts a on a.accountid = t.accountid
join customers c on c.customerid = a.customerid
where t.date = "2023-10-02";

/*total amount credited or debited into customers acc on a particular day*/
select c.customerid, c.name, sum(t.amount) as amount, t.type
from transactions t 
join accounts a on a.accountid = t.accountid
join customers c on c.customerid = a.customerid
where t.type = "credit" and t.date = "2023-10-02" group by c.customerid,c.name;

/*no.of times amt is credited or credited into customers acc*/
select c.name,c.customerid,count(t.transactionid) as no_of_transc,
sum(case when t.type = "credit" then 1 else 0 end) as credit,
SUM(CASE WHEN t.type = 'credit' THEN t.amount ELSE 0 END) AS total_credit_amount,
sum(case when t.type = "debit" then 1 else 0 end) as debit,
SUM(CASE WHEN t.type = 'debit' THEN t.amount ELSE 0 END) AS total_debited_amount
from transactions t 
join accounts a on a.accountID = t.accountid
join customers c on c.customerid = a.customerid
group by c.customerid,c.name order by no_of_transc desc;

/*no.of credit and debit transactions*/
select  t.type,count(t.type) as transc_count
from transactions t 
group by t.type;

/*total amt credited or debited in customers account*/
select a.accountid,sum(t.amount) as total_amt, t.type,c.name
from transactions t join accounts a on a.accountid = t.accountid
join customers c on a.customerid = c.CustomerID
group by t.type,a.accountid,c.name;

/*customers with no.of credits and debits*/
select c.name,sum(case when t.type = "credit" then 1 else 0 end) as credit_acc,
sum(case when t.type = "debit" then 1 else 0 end) as debit_acc, count(t.transactionid) as n0_of_transc
from transactions t join accounts a on a.accountid = t.accountid
join customers c on c.customerid = a.customerid
group by c.name,t.type;

/*filtering customers with credit_amt > debit_amt*/
select c.name, sum(case when t.type = "credit" then t.amount else 0 end) as credit_amt,
sum(case when t.type = "debit" then t.amount else 0 end) as debit_amt
from transactions t join accounts a on a.accountid = t.accountid
join customers c on c.customerid = a.customerid
group by c.name having credit_amt > debit_amt;


/*customers with more than one acc*/
select c.customerid,c.name, count(a.accountid) as count_of_acc
from customers c join accounts a on c.customerid = a.customerid
group by c.customerid,c.name having count(a.accountid) > 1;

/*customers with atleast one loan*/
select c.customerid,c.name, count(l.loanid) as count_of_loans,
sum(case when l.type = "car loan" then 1 else 0 end) as car,
sum(case when l.type = "personal loan" then 1 else 0 end) as personal,
sum(case when l.type = "education loan" then 1 else 0 end) as education,
sum(case when l.type = "home loan" then 1 else 0 end) as Home
from customers c join loans l on c.customerid = l.customerid
group by c.customerid,c.name having count(l.loanid) >= 1;

/*customers with atleast one card*/
select c.name,c.customerid,count(ca.cardid) as no_of_cards,
sum(case when ca.type = "credit" then 1 else 0 end) as credit,
sum(case when ca.type = "debit" then 1 else 0 end) as debit
from cards ca join customers c on c.CustomerID = ca.customerid
group by c.customerid, c.name having no_of_cards >= 1;

/*customers who have a card and a loan but no transactions in any account*/
select c.name,c.customerid
from customers c join accounts a on c.CustomerID = a.customerid
left join transactions t on t.accountid = a.accountid
join cards ca on ca.customerid = c.customerid
join loans l on l.customerid = c.customerid
where t.transactionid is Null
group by c.name,c.customerid;

/*customers whos total loan amt is > total balance*/
select c.name,c.customerid
from customers c join loans l on l.customerid = c.customerid
join accounts a on a.customerid = c.customerid
group by c.name,c.customerid having sum(a.balance) < sum(l.amount);

/*customers and their net financial position*/
select c.name, c.customerid, sum(a.balance) as total_balance, sum(l.amount) as loan_amt,
sum(a.balance) - sum(l.amount) as financial_balance
from customers c join loans l on l.customerid = c.customerid
join accounts a on a.customerid = c.customerid
group by c.name,c.customerid having financial_balance < 0;