-- Drop tables to start from scratch for report building
DROP TABLE IF EXISTS report_detailed;
DROP TABLE IF EXISTS report_summary;

-- Load data from customer and payment tables and insert into detailed table. Create table as select.
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
    p.payment_id --payment
INTO report_detailed
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
ORDER BY c.store_id, c.customer_id, p.payment_date


-- Create report_summary table, including three new calculated columns: total_spend, avg_spend_per_month, and date_of_last_purchase
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
INTO report_summary
FROM report_detailed
GROUP BY store_id, customer_id, first_name, last_name, email, create_date
ORDER BY store_id, customer_id;

-- Stored procedure to refresh the data in both the detailed table and summary table. The procedure should clear the contents of the detailed table and summary table and perform the raw data extraction and transformation steps again.
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
        p.payment_date, --payment
        p.payment_id --payment
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

-- Trigger to call the refresh_reports function whenever a new row is inserted into the payment table
CREATE TRIGGER refresh_reports
AFTER INSERT ON payment
FOR EACH ROW
EXECUTE PROCEDURE refresh_reports();

-- Test the trigger and select from the detailed table to see the results
INSERT INTO payment VALUES (999999, 1, 1, 1, 2.99, '2021-01-01 00:00:00.000000');
SELECT * FROM report_detailed WHERE payment_id = 999999;
ORDER BY payment_date DESC;

-- Delete test data
DELETE FROM payment WHERE payment_id = 999999;
