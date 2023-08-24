-- Drop tables to start from scratch for report building
DROP TABLE IF EXISTS detailed;
DROP TABLE IF EXISTS report_detailed;
DROP TABLE IF EXISTS report_summary;

-- Create detailed table
CREATE TABLE report_detailed(
    store_id integer, --customer
    customer_id integer, --customer, payment
    first_name varchar(45), --customer
    last_name varchar(45), --customer
    email varchar(90), --customer
    create_date timestamp, --customer
    amount double precision, --payment
    payment_date timestamp --payment
)


-- Load data from customer and payment tables and insert into detailed table
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

INSERT INTO report_summary(
    store_id,
    customer_id,
    first_name,
    last_name,
    email,
    create_date,
    total_spend,
    avg_spend_per_month,
    date_of_last_purchase
)
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
ORDER BY store_id, customer_id;