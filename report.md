Anthony Hart
000956500
Advanced Data Management – D191

# Business Report

#### A.  Summarize one real-world written business report that can be created from the DVD Dataset from the “Labs on Demand Assessment Environment and DVD Database” attachment.
- One real-world business report that can be generated from the DVD Dataset is Most Valuable Inactive Customers by Store, which would identify the top 10 spenders of all customers marked as inactive. The business could then perform market research on those customers, asking why they are no longer actively renting DVDs from their business, potentially addressing a larger issue at the organization (such as too costly of late fees, poor experience, or lack of desired inventory).

#### 1.  Identify the specific fields that will be included in the detailed table and the summary table of the report.
Summary Table
- Customer : store_id
- Customer : name
- Payment : amount (sum)
- Calculation : total_spend
- Calculation : avg_spend_per_month
- Calculation : date_of_last_purchase

Detailed Table
- Customer : customer_id
- Customer : store_id
- Customer : first_name
- Customer : last_name
- Customer : email
- Customer : create_date
- Payment : amount
- Payment : payment_date

#### 2.  Describe the types of data fields used for the report.
- The data used for this report would be the customer information and payment information. 
- The users of the business report can perform market research using the customer data to identify why they are no longer actively renting DVDs from their business. Reaching out to the customer list could lead to identifying core issues driving customers away, such as too costly of late fees, poor experience, or lack of desired inventory.
- The payment information would give the users information regarding how much potential revenue they are missing out on (e.g., a customer was spending $100 per month in rentals but is no longer active). If the lost revenue is too small, though, this report would inform the users to look elsewhere for increasing revenue – potentially via the use of other reports.

#### 3.  Identify at least two specific tables from the given dataset that will provide the data necessary for the detailed table section and the summary table section of the report.
- The Customer and Payment tables will provide details for both types of reports.

#### 4.  Identify at least one field in the detailed table section that will require a custom transformation with a user-defined function and explain why it should be transformed (e.g., you might translate a field with a value of N to No and Y to Yes).
- The detailed table section 
- The summary table will require three calculated fields: total amount spent, average spend per month, date of last rental.

#### 5.  Explain the different business uses of the detailed table section and the summary table section of the report.
- The summary table section is designed to give the management team insight into more strategic data. For example, the summary table is designed to present the minimal information required for management to decide whether attempting to regain these customers are a worthwhile endeavor. Management could state that any inactive users with more than an average spend of $25 per month are worth attempting to regain as customers.
- The detailed table, though, is designed to showcase the exact numbers to provide more insight if management requests more detail. For example, if a customer spent $2,000 over the course of 10 years, management may ask why they are no longer a customer. Looking at the detail may show that this particular “customer” had a consistent spend except for the previous year, which would then require more questions to determine if that was because of a change in business practice (such as increasing late-fees) or it could be that the customer lost their job. Ultimately, the detailed table is designed to provide more insight into questions derived from the summary table, which would likely require action on the business (potentially building more reports as trends are uncovered). 

#### 6.  Explain how frequently your report should be refreshed to remain relevant to stakeholders.
- The report should be updated anytime a customer’s active flag is changed, either from TRUE to FALSE or visa-versa. If a customer goes from active to inactive, the business will want to include their details in the report. If the opposite happens, the business will want to exclude their data, as it’s no longer relevant to the question being posed against the data. 

#### B.  Provide original code for function(s) in text format that perform the transformation(s) you identified in part A4.
SELECT
    c.first_name || ' ' || c.last_name AS full_name, --customer
FROM customer c

#### C.  Provide original SQL code in a text format that creates the detailed and summary tables to hold your report table sections.
-- Create report_detailed table
CREATE TABLE report_detailed(
    store_id integer,
    customer_id integer,
    first_name varchar(45),
    last_name varchar(45),
    email varchar(90),
    create_date timestamp,
    amount double precision,
    payment_date timestamp
)

-- Create report_summary table, including three new calculated columns: total_spend, avg_spend_per_month, and date_of_last_purchase
CREATE TABLE report_summary(
    store_id integer,
    customer_id integer,
    first_name varchar(45),
    last_name varchar(45),
    email varchar(90),
    create_date timestamp,
    total_spend double precision,
    avg_spend_per_month double precision,
    date_of_last_purchase timestamp
)

#### D.  Provide an original SQL query in a text format that will extract the raw data needed for the detailed section of your report from the source database.
INSERT INTO report_detailed(
    store_id, --customer
    customer_id, --customer, payment
    first_name, --customer
    last_name, --customer
    email, --customer 
    create_date, --customer
    amount, --payment
    payment_date --payment
)
SELECT
    c.store_id, --customer
    c.customer_id, --customer, payment
    c.first_name, --customer
    c.last_name, --customer
    c.email, --customer
    c.create_date, --customer
    p.amount, --payment
    p.payment_date --payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
ORDER BY c.store_id, c.customer_id, p.payment_date;

#### E.  Provide original SQL code in a text format that creates a trigger on the detailed table of the report that will continually update the summary table as data is added to the detailed table.
CREATE TRIGGER refresh_reports
AFTER INSERT ON payment
FOR EACH ROW
EXECUTE PROCEDURE refresh_reports();

#### F.  Provide an original stored procedure in a text format that can be used to refresh the data in both the detailed table and summary table. The procedure should clear the contents of the detailed table and summary table and perform the raw data extraction from part D.
CREATE OR REPLACE FUNCTION refresh_reports()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM report_detailed; --clear the contents of the detailed table
DELETE FROM report_summary; --clear the contents of the summary table
INSERT INTO report_detailed(
    SELECT
        c.store_id, --customer
        c.customer_id, --customer, payment
        c.first_name, --customer
        c.last_name, --customer
        c.first_name || ' ' || c.last_name AS full_name, --customer
        c.email, --customer
        c.create_date, --customer
        p.amount, --payment
        p.payment_date --payment
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    ORDER BY c.store_id, c.customer_id, p.payment_date
);
INSERT INTO report_summary( 
    SELECT 
        store_id,
        customer_id,
        first_name,
        last_name,
        email,
        create_date,
        SUM(amount) AS total_spend,
        SUM(amount)/COUNT(DISTINCT DATE_TRUNC('month', payment_date)) AS avg_spend_per_month,
        MAX(payment_date) AS date_of_last_purchase
    FROM report_detailed
    GROUP BY store_id, customer_id, first_name, last_name, email, create_date
    ORDER BY store_id, customer_id
);
RETURN NULL;
END; $$

#### G.  Provide a Panopto video recording that includes the presenter and a vocalized demonstration of the functionality of the code used for the analysis.


#### H.  Acknowledge all utilized sources, including any sources of third-party code, using in-text citations and references. If no sources are used, clearly declare that no sources were used to support your submission.

#### I.  Demonstrate professional communication in the content and presentation of your submission.