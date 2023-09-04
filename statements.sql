-- Generate Detailed Report table --
-- Report details all payments made by inactive customers --
DROP TABLE IF EXISTS inactive_customers;
SELECT
    c.store_id,
    c.customer_id,
    c.active,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    c.create_date,
    p.amount,
    p.payment_date,
    p.payment_id
INTO inactive_customers
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE active = 0
ORDER BY c.store_id, c.customer_id, p.payment_date;

-- View the detailed report table --
SELECT * FROM inactive_customers;



-- Generate Summary Report table --
-- Report indicates loss of revenue due to inactive customers per store --
DROP TABLE IF EXISTS inactive_customers_by_store;
SELECT
    store_id,
    COUNT(DISTINCT customer_id) AS num_inactive_customers,
    SUM(amount)/COUNT(DISTINCT DATE_TRUNC('month', payment_date))/num_inactive_customers AS avg_spend_per_month,
    COUNT(store_id) AS num_payments
INTO inactive_customers_by_store
FROM inactive_customers
GROUP BY store_id

-- View the summary report table --
SELECT * FROM inactive_customers_by_store;



-- Refresh data in the summary report by clearing all data and re-running the query --
CREATE OR REPLACE FUNCTION refresh_inactive_customers_by_store()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM inactive_customers_by_store;
    INSERT INTO inactive_customers_by_store
    SELECT
        store_id,
        COUNT(DISTINCT customer_id) AS num_inactive_customers,
        SUM(amount)/COUNT(DISTINCT DATE_TRUNC('month', payment_date))/num_inactive_customers AS avg_spend_per_month,
        COUNT(store_id) AS num_payments
    FROM inactive_customers
    GROUP BY store_id;
    RETURN NEW;
END; 
$$;

-- Create a trigger to refresh the summary report table after each update --
CREATE TRIGGER new_inactive_customer
    AFTER INSERT ON inactive_customers
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_inactive_customers_by_store();

CREATE TRIGGER delete_inactive_customer
    AFTER DELETE ON inactive_customers
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_inactive_customers_by_store();

-- Test the triggers by inserting and deleting a row in inactive_customers --
INSERT INTO inactive_customers VALUES (3, 600, 0, 'Test User', 'email@abc.com', '2023-01-01', 99.99, '2021-01-01 09:28:31.996577', 32999);

SELECT COUNT(*) FROM inactive_customers;
SELECT SUM(num_payments) FROM inactive_customers_by_store;
SELECT * FROM inactive_customers_by_store;

DELETE FROM inactive_customers WHERE customer_id = 600;