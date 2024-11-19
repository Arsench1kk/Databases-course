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

CREATE ROLE junior_dev WITH LOGIN PASSWORD '0805';

CREATE VIEW salesmen_new_york AS
SELECT *
FROM salesman
WHERE city = 'New York';
--проверка
SELECT * FROM salesmen_new_york;
--
GRANT CONNECT ON DATABASE lab8 TO junior_dev;
GRANT USAGE ON SCHEMA public TO junior_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO junior_dev;

CREATE VIEW order_details AS
SELECT
    o.ord_no,
    o.purch_amt,
    o.ord_date,
    c.cust_name AS customer_name,
    s.name AS salesman_name
FROM
    orders o
JOIN
    customers c ON o.customer_id = c.customer_id
JOIN
    salesman s ON o.salesman_id = s.salesman_id;
GRANT SELECT, INSERT, UPDATE, DELETE ON order_details TO junior_dev;
--проверка
SELECT * FROM order_details;


CREATE VIEW top_customers AS
SELECT *
FROM customers
WHERE grade = (SELECT MAX(grade) FROM customers);
GRANT SELECT ON top_customers TO junior_dev;
--проверка
SELECT * FROM top_customers;
SELECT * FROM top_customers;

CREATE VIEW salesman_count_by_city AS
SELECT
    city,
    COUNT(*) AS salesman_count
FROM
    salesman
GROUP BY
    city;
--проверка
SELECT * FROM salesman_count_by_city;

CREATE VIEW salesmen_with_multiple_customers AS
SELECT
    s.salesman_id,
    s.name AS salesman_name,
    s.city AS salesman_city,
    COUNT(c.customer_id) AS customer_count
FROM
    salesman s
JOIN
    customers c ON s.salesman_id = c.salesman_id
GROUP BY
    s.salesman_id, s.name, s.city
HAVING
    COUNT(c.customer_id) > 1;
--проверка
SELECT * FROM salesmen_with_multiple_customers;

CREATE ROLE intern;
GRANT junior_dev TO intern;

--проверка
GRANT intern TO some_user;