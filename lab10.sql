--DROP DATABASE IF EXISTS lab10;
CREATE DATABASE lab10;

CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0)
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (book_id) REFERENCES Books (book_id),
    FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);
INSERT INTO Books (title, author, price, quantity) VALUES
('Database 101', 'A. Smith', 40.00, 10),
('Learn SQL', 'B. Johnson', 35.00, 15),
('Advanced DB', 'C. Lee', 50.00, 5),
('Web Development Basics', 'D. Brown', 45.00, 8),
('Python Programming', 'E. Davis', 55.00, 12);

INSERT INTO Customers (name, email) VALUES
('John Doe', 'johndoe@example.com'),
('Jane Doe', 'janedoe@example.com'),
('Bob Smith', 'bobsmith@example.com'),
('Alice Johnson', 'alicejohnson@example.com'),
('Charlie Brown', 'charliebrown@example.com');

INSERT INTO Orders (book_id, customer_id, order_date, quantity) VALUES
(1, 1, '2023-06-01', 1),
(2, 2, '2023-06-02', 2),
(3, 3, '2023-06-03', 1),
(4, 4, '2023-06-04', 1),
(5, 5, '2023-06-05', 2),
(1, 2, '2023-06-06', 1),
(2, 3, '2023-06-07', 1),
(3, 4, '2023-06-08', 1),
(4, 5, '2023-06-09', 2),
(5, 1, '2023-06-10', 1);
--ROLLBACK;
BEGIN;
INSERT INTO Orders (book_id, customer_id, order_date, quantity)
VALUES (1, 1, CURRENT_DATE, 2);
UPDATE Books
SET quantity = quantity - 2
WHERE book_id = 1;
COMMIT;
--чек
SELECT * FROM Orders WHERE customer_id = 1 ORDER BY order_id DESC LIMIT 1;
SELECT quantity FROM Books WHERE book_id = 1;

CREATE OR REPLACE FUNCTION place_order_with_check(
    p_book_id INT,
    p_customer_id INT,
    p_quantity INT
) RETURNS BOOLEAN AS $$
DECLARE
    v_available_quantity INT;
BEGIN
    SELECT quantity INTO v_available_quantity
    FROM Books
    WHERE book_id = p_book_id
    FOR UPDATE;
    IF v_available_quantity >= p_quantity THEN
        INSERT INTO Orders (book_id, customer_id, order_date, quantity)
        VALUES (p_book_id, p_customer_id, CURRENT_DATE, p_quantity);
        UPDATE Books
        SET quantity = quantity - p_quantity
        WHERE book_id = p_book_id;
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'Not enough books available. Required: %, Available: %', p_quantity, v_available_quantity;
    END IF;
END;
$$ LANGUAGE plpgsql;
--чек
SELECT place_order_with_check(3, 2, 10);
SELECT * FROM Orders WHERE customer_id = 2 ORDER BY order_id DESC LIMIT 1;
SELECT quantity FROM Books WHERE book_id = 3;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
UPDATE Books SET price = 45.00 WHERE book_id = 1;
--
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
-- старая(но новая)
SELECT price FROM Books WHERE book_id = 1;
--
-- новая
SELECT price FROM Books WHERE book_id = 1;
COMMIT;

BEGIN;--долговечность
UPDATE Customers
SET email = 'john.doe.new@example.com'
WHERE customer_id = 1;
COMMIT;
--чек
SELECT * FROM Customers WHERE customer_id = 1;
