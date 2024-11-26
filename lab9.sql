SELECT current_database();
DROP DATABASE IF EXISTS lab8;
DROP TABLE IF EXISTS salesmen;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;
CREATE DATABASE lab8;

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(3, 2)
);

INSERT INTO salesman (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', 'Rome', 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT REFERENCES salesman(salesman_id)
);

INSERT INTO customers (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', 100, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10, 2),
    ord_date DATE,
    customer_id INT REFERENCES customers(customer_id),
    salesman_id INT REFERENCES salesman(salesman_id)
);

INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3005, 5002),
(70008, 5760.0, '2012-09-10', 3002, 5001);

CREATE OR REPLACE FUNCTION increase_value(input_value INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN input_value + 10;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT increase_value(5);

CREATE OR REPLACE FUNCTION compare_numbers(
    num1 INTEGER,
    num2 INTEGER,
    OUT result VARCHAR(7)
) AS $$
BEGIN
    IF num1 > num2 THEN
        result := 'Greater';
    ELSIF num1 < num2 THEN
        result := 'Lesser';
    ELSE
        result := 'Equal';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT compare_numbers(5, 3);

CREATE OR REPLACE FUNCTION number_series(n INTEGER)
RETURNS SETOF INTEGER AS $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..n LOOP
        RETURN NEXT i;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM number_series(5);

CREATE OR REPLACE FUNCTION find_employee(employee_name VARCHAR)
RETURNS TABLE (
    salesman_id INTEGER,
    name VARCHAR,
    city VARCHAR,
    commission DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT s.salesman_id, s.name, s.city, s.commission
    FROM salesman s
    WHERE s.name ILIKE '%' || employee_name || '%';
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM find_employee('James');

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 999.99),
('Smartphone', 'Electronics', 599.99),
('T-shirt', 'Clothing', 19.99),
('Jeans', 'Clothing', 49.99);

CREATE OR REPLACE FUNCTION list_products(category_name VARCHAR)
RETURNS TABLE (
    product_id INTEGER,
    product_name VARCHAR,
    price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.product_id, p.product_name, p.price
    FROM products p
    WHERE p.category = category_name;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM list_products('Electronics');

CREATE OR REPLACE FUNCTION calculate_bonus(salary DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN salary * 0.1; -- 10% bonus
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_salary(
    employee_id INTEGER,
    current_salary DECIMAL
)
RETURNS DECIMAL AS $$
DECLARE
    new_salary DECIMAL;
    bonus DECIMAL;
BEGIN
    bonus := calculate_bonus(current_salary);
    new_salary := current_salary + bonus;

    -- Assuming you have an employees table, you would update it here
    -- UPDATE employees SET salary = new_salary WHERE id = employee_id;

    RETURN new_salary;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT update_salary(1, 50000);

CREATE OR REPLACE FUNCTION complex_calculation(
    num1 INTEGER,
    num2 INTEGER,
    text_input VARCHAR
)
RETURNS JSON AS $$
<<main_block>>
DECLARE
    result JSON;
    numeric_result INTEGER;
    text_result VARCHAR;
BEGIN
    <<numeric_block>>
    DECLARE
        temp INTEGER;
    BEGIN
        temp := num1 * num2;
        numeric_result := temp + LENGTH(text_input);
    END numeric_block;

    <<text_block>>
    DECLARE
        reversed_text VARCHAR;
    BEGIN
        reversed_text := REVERSE(text_input);
        text_result := CONCAT(UPPER(SUBSTRING(reversed_text, 1, 1)), LOWER(SUBSTRING(reversed_text, 2)));
    END text_block;

    result := json_build_object(
        'numeric_result', numeric_result,
        'text_result', text_result,
        'combined_result', CONCAT(text_result, ' ', numeric_result::VARCHAR)
    );

    RETURN result;
END main_block;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT complex_calculation(5, 3, 'Hello');