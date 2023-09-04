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
-- Report indicates average loss of revenue per month due to inactive customers at each store --
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



-- Refresh data in the DETAIL report by clearing all data and re-inserting it --
CREATE OR REPLACE FUNCTION refresh_inactive_customers()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM inactive_customers;
    INSERT INTO inactive_customers
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
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    WHERE active = 0
    ORDER BY c.store_id, c.customer_id, p.payment_date;
    RETURN NEW;
END;
$$;
-- Create a trigger to refresh inactive_customers after each update or delete --
CREATE TRIGGER customer_update_or_delete
    AFTER INSERT UPDATE OR DELETE ON customer
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_inactive_customers();



-- Refresh data in the SUMMARY report by clearing all data and re-insterting it--
CREATE OR REPLACE FUNCTION refresh_inactive_customers_by_store()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM inactive_customers_by_store;
    INSERT INTO inactive_customers_by_store
    SELECT
        store_id,
        COUNT(DISTINCT customer_id) AS num_inactive_customers,
        SUM(amount)/COUNT(DISTINCT DATE_TRUNC('month', payment_date))/num_inactive_customers AS avg_loss_per_month,
        COUNT(store_id) AS num_payments
    FROM inactive_customers
    GROUP BY store_id;
    RETURN NEW;
END; 
$$;
-- Create a trigger to refresh the SUMMARY report table after each insert or delete --
CREATE TRIGGER inactive_customer_update
    AFTER INSERT OR DELETE ON inactive_customers
    FOR EACH STATEMENT
    EXECUTE PROCEDURE refresh_inactive_customers_by_store();


-- TESTING --
-- Update customer to inactive and set store_id=3 for easy finding --
UPDATE customer SET active=0, store_id=3 WHERE customer_id = 100;

-- Compare Summary and Detailed report for row changes --
SELECT COUNT(*) FROM inactive_customers;
SELECT SUM(num_payments) FROM inactive_customers_by_store;
SELECT * FROM inactive_customers_by_store;

-- Revert changes to customer | done testing --
UPDATE customer SET active=1, store_id=1 WHERE customer_id = 100;
