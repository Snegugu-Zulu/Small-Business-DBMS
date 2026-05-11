DROP DATABASE IF EXISTS small_business_db;

CREATE DATABASE small_business_db;
USE small_business_db;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    join_date DATE DEFAULT (CURRENT_DATE),
    loyalty_points INT DEFAULT 0
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE,
    position VARCHAR(50),
    salary DECIMAL(10, 2)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    cost DECIMAL(10, 2),
    stock_quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 10,
    supplier VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (first_name, last_name, email, phone, address, city, state, zip_code, loyalty_points) VALUES
('Snegugu', 'Zulu', 'snegugu.zulu@email.com', '+27 71 234 5678', '15 Mandela Square, Sandton', 'Johannesburg', 'Gauteng', '2196', 150),
('John', 'Smith', 'john@email.com', '555-0101', '123 Main St', 'New York', 'NY', '10001', 75),
('Sarah', 'Johnson', 'sarah@email.com', '555-0102', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 200),
('Mike', 'Brown', 'mike@email.com', '555-0103', '789 Pine Rd', 'Chicago', 'IL', '60601', 50),
('Thabo', 'Nkosi', 'thabo.nkosi@email.com', '+27 82 345 6789', '23 Vilakazi Street', 'Johannesburg', 'Gauteng', '1804', 80);

INSERT INTO employees (first_name, last_name, email, phone, hire_date, position, salary) VALUES
('Robert', 'Wilson', 'robert@business.com', '555-0201', '2022-01-15', 'Manager', 55000),
('Lisa', 'Anderson', 'lisa@business.com', '555-0202', '2022-03-20', 'Sales', 38000),
('Nomusa', 'Dlamini', 'nomusa.dlamini@business.com', '+27 83 456 7890', '2023-02-10', 'Sales Associate', 35000);

INSERT INTO products (product_name, sku, category, price, cost, stock_quantity, reorder_level, supplier) VALUES
('Smartphone', 'PHONE001', 'Electronics', 699.99, 450.00, 50, 10, 'TechSupply Co'),
('Laptop', 'LAP001', 'Electronics', 999.99, 700.00, 25, 5, 'TechSupply Co'),
('Jeans', 'CLOTH001', 'Clothing', 49.99, 25.00, 100, 20, 'Fashion Wholesale'),
('T-Shirt', 'CLOTH002', 'Clothing', 19.99, 8.00, 200, 50, 'Fashion Wholesale'),
('Novel Book', 'BOOK001', 'Books', 14.99, 7.50, 75, 15, 'Book Distributors'),
('Traditional Beads', 'CRAFT001', 'Crafts', 29.99, 12.00, 150, 20, 'Local Crafts SA');

INSERT INTO orders (customer_id, employee_id, status) VALUES
(1, 3, 'Delivered'),   -- Snegugu's first order
(1, 3, 'Shipped'),     -- Snegugu's second order
(2, 2, 'Delivered'),   -- John's order
(3, 2, 'Shipped'),     -- Sarah's order
(4, NULL, 'Pending'),  -- Mike's order
(5, 3, 'Delivered');   -- Thabo's order

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
-- Snegugu's first order (order_id = 1)
(1, 1, 1, 699.99),
(1, 6, 1, 29.99),
(1, 5, 1, 14.99),
-- Snegugu's second order (order_id = 2)
(2, 3, 1, 49.99),
-- John's order (order_id = 3)
(3, 1, 1, 699.99),
(3, 3, 1, 49.99),
-- Sarah's order (order_id = 4)
(4, 3, 1, 49.99),
-- Mike's order (order_id = 5)
(5, 2, 1, 999.99),
(5, 5, 1, 14.99),
-- Thabo's order (order_id = 6)
(6, 1, 1, 699.99);

UPDATE orders o
JOIN (
    SELECT order_id, SUM(quantity * price) as calculated_total
    FROM order_items
    GROUP BY order_id
) oi ON o.order_id = oi.order_id
SET o.total_amount = oi.calculated_total;

SET SQL_SAFE_UPDATES = 1;

SELECT '=== SNEGUGU ZULU PROFILE ===' as '';
SELECT * FROM customers WHERE first_name = 'Snegugu';

SELECT '=== SNEGUGU\'S ORDERS ===' as '';
SELECT o.order_id, o.order_date, o.status, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.first_name = 'Snegugu';

SELECT '=== ALL CUSTOMERS ===' as '';
SELECT customer_id, first_name, last_name, city, loyalty_points FROM customers;

SELECT '=== ORDERS SUMMARY ===' as '';
SELECT order_id, customer_id, status, total_amount FROM orders;