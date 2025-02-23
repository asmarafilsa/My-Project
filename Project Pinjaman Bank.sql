CREATE TABLE public.bank_loan(
	id INT PRIMARY KEY,
	address_state VARCHAR(50),
	application_type VARCHAR(50),
	emp_length VARCHAR(50),
	emp_title VARCHAR(100),
	grade VARCHAR(50),
	home_ownership VARCHAR(50),
	issue_date TEXT,
	last_credit_pull_date TEXT,
	last_payment_date TEXT,
	loan_status VARCHAR(50),
	next_payment_date TEXT,
	member_id INT,
	purpose VARCHAR(50),
	sub_grade VARCHAR(50),
	term VARCHAR(50),
	verification_status VARCHAR(50),
	annual_income FLOAT,
	dti FLOAT,
	installment FLOAT,
	int_rate FLOAT,
	loan_amount INT,
	total_acc INT,
	total_payment INT	
);

ALTER TABLE public.bank_loan
ALTER COLUMN issue_date TYPE DATE
USING TO_DATE(issue_date, 'DD-MM-YYYY');

ALTER TABLE public.bank_loan
ALTER COLUMN next_payment_date TYPE DATE
USING TO_DATE(next_payment_date, 'DD-MM-YYYY');

SELECT COUNT(id) AS PMTotal_Loan_Application
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 
AND EXTRACT(YEAR FROM issue_date) = 2021

SELECT SUM(loan_amount) AS MDT_Total_Funded_Amount
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 
AND EXTRACT(YEAR FROM issue_date) = 2021

SELECT SUM(total_payment) AS Total_Amount_Receive
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 
AND EXTRACT(YEAR FROM issue_date) = 2021

SELECT ROUND(CAST(AVG(int_rate) AS NUMERIC) * 100, 3) AS Average_Interest_Rate
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 
AND EXTRACT(YEAR FROM issue_date) = 2021

SELECT ROUND(CAST(AVG(dti) AS NUMERIC) * 100, 3) AS Average_DTI
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11 
AND EXTRACT(YEAR FROM issue_date) = 2021

SELECT
    COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100
    /
    COUNT(id) AS Good_Loan_Percentage
FROM bank_loan;

SELECT COUNT(id) AS Good_Loan_Application
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

SELECT SUM(total_payment) AS Good_Loan_Received_Amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

SELECT
    loan_status,
    COUNT(id) AS LoanCount,
    SUM(total_payment) AS MTD_Total_Amount_Received,
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM 
	bank_loan
WHERE
    EXTRACT(MONTH FROM issue_date) = 12
    AND EXTRACT(YEAR FROM issue_date) = 2021
GROUP BY
    loan_status;

SELECT 
	emp_length,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM
	bank_loan
GROUP BY 
	emp_length
ORDER BY
	emp_length

SELECT * FROM bank_loan