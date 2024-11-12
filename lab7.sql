--DROP DATABASE lab7;
CREATE DATABASE lab7;

CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO countries (name) VALUES
    ('Kazakhstan'), ('Russia'), ('USA'), ('Canada'), ('Germany');


CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    department_id INT
);

INSERT INTO employees (name, surname, salary, department_id) VALUES
    ('John', 'Doe', 50000.00, 1),
    ('Jane', 'Smith', 60000.00, 2),
    ('Emily', 'Johnson', 70000.00, 3),
    ('Chris', 'Evans', 45000.00, 1),
    ('Anna', 'Taylor', 80000.00, 2);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    budget DECIMAL(10, 2) NOT NULL
);

INSERT INTO departments (department_name, budget) VALUES
    ('HR', 100000.00),
    ('Engineering', 200000.00),
    ('Marketing', 150000.00);


-- 1. SELECT * FROM countries WHERE name = ‘string’;
CREATE INDEX idx_countries_name ON countries(name);


-- 2.SELECT * FROM employees WHERE name = ‘string’
-- AND surname = ‘string’;
CREATE INDEX idx_employees_name_surname ON employees(name, surname);

-- 3. SELECT * FROM employees WHERE salary < value1
-- AND salary > value2;
CREATE UNIQUE INDEX idx_employees_salary_range ON employees(salary);

-- 4. SELECT * FROM employees WHERE substring(name
-- from 1 for 4) = ‘abcd’;
CREATE INDEX idx_employees_name_prefix ON employees((substring(name FROM 1 FOR 4)));

-- 5. SELECT * FROM employees e JOIN departments d
-- ON d.department_id = e.department_id WHERE
-- d.budget > value2 AND e.salary < value2;
CREATE INDEX idx_departments_budget ON departments(budget);
CREATE INDEX idx_employees_salary ON employees(salary);
