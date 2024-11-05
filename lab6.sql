--DROP DATABASE lab6;
--DROP TABLE locations, departments,employees IF EXISTS;
CREATE DATABASE lab6;

CREATE TABLE locations(
    location_id SERIAL PRIMARY KEY,
    street_address VARCHAR(25),
    postal_code VARCHAR(12),
    city VARCHAR(30),
    state_province VARCHAR(12)
);

CREATE TABLE departments(
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE,
    budget INTEGER,
    location_id INTEGER REFERENCES locations
);

CREATE TABLE employees(
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20),
    salary INTEGER,
    department_id INTEGER REFERENCES departments
);
INSERT INTO locations (street_address, postal_code, city, state_province)
VALUES
    ('123 Elm St', '12345', 'New York', 'NY'),
    ('456 Oak Ave', '67890', 'Los Angeles', 'CA'),
    ('789 Maple Rd', '11223', 'Chicago', 'IL'),
    ('101 Pine St', '54321', 'Houston', 'TX'),
    ('202 Cedar Ave', '67891', 'Phoenix', 'AZ'),
    ('303 Birch Rd', '11224', 'Philadelphia', 'PA'),
    ('404 Walnut St', '98765', 'San Antonio', 'TX'),
    ('505 Spruce Ln', '87654', 'San Diego', 'CA'),
    ('606 Redwood Blvd', '54322', 'Dallas', 'TX');

INSERT INTO departments (department_name, budget, location_id)
VALUES
    ('HR', 50000, 1),
    ('IT', 100000, 2),
    ('Finance', 75000, 3),
    ('Marketing', 60000, 4),
    ('Sales', 90000, 5),
    ('Customer Support', 55000, 6),
    ('Operations', 80000, 7),
    ('Engineering', 120000, 8),
    ('Product Development', 110000, 9);

INSERT INTO employees (first_name, last_name, email, phone_number, salary, department_id)
VALUES
    ('Alice', 'Smith', 'alice.smith@example.com', '555-1234', 60000, 1),
    ('Bob', 'Brown', 'bob.brown@example.com', '555-5678', 75000, 2),
    ('Charlie', 'Davis', 'charlie.davis@example.com', '555-8765', 50000, NULL),  -- Сотрудник без отдела
    ('Diana', 'Clark', 'diana.clark@example.com', '555-4321', 82000, 3),
    ('Evan', 'Green', 'evan.green@example.com', '555-3456', 56000, 4),
    ('Fiona', 'Harris', 'fiona.harris@example.com', '555-7890', 67000, 5),
    ('George', 'Ivy', 'george.ivy@example.com', '555-6543', 59000, 6),
    ('Helen', 'Johnson', 'helen.johnson@example.com', '555-2109', 83000, 7),
    ('Ivan', 'King', 'ivan.king@example.com', '555-8765', 95000, 8),
    ('Julia', 'Lopez', 'julia.lopez@example.com', '555-3456', 91000, 9),
    ('Kevin', 'Moore', 'kevin.moore@example.com', '555-9876', 64000, 1),
    ('Lily', 'Nelson', 'lily.nelson@example.com', '555-5432', 70000, NULL);  -- Добавлено NULL для department_id

--3
SELECT first_name, last_name, employees.department_id, department_name
FROM employees
LEFT JOIN departments d ON employees.department_id = d.department_id;

--4
SELECT first_name, last_name, employees.department_id, department_name
FROM employees
LEFT JOIN departments d ON employees.department_id = d.department_id
WHERE employees.department_id IN (8, 4);

--5
SELECT first_name, last_name, employees.department_id, city, state_province
FROM employees
LEFT JOIN departments d on d.department_id = employees.department_id
LEFT JOIN locations l on d.location_id = l.location_id;

--6
SELECT department_name, first_name, last_name
FROM  departments
LEFT JOIN  employees ON departments.department_id = employees.department_id;

--7
SELECT first_name, last_name, departments.department_id, department_name
FROM employees
LEFT JOIN  departments ON employees.department_id = departments.department_id;
