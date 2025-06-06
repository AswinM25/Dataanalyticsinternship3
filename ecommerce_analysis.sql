--To create a database:

CREATE DATABASE ecommerce_db;
USE ecommerce_db;

--Create ecommerce table:

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

--Insert values:
-- Customers
INSERT INTO Customers (name, email, country) VALUES
('Alice', 'alice@gmail.com', 'USA'),
('Bob', 'bob@gmail.com', 'UK'),
('Charlie', 'charlie@gmail.com', 'India');

-- Products
INSERT INTO Products (name, category, price) VALUES
('Laptop', 'Electronics', 1000.00),
('Phone', 'Electronics', 500.00),
('T-Shirt', 'Clothing', 25.00),
('Book', 'Books', 15.00);

-- Orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2024-05-01', 1025.00),
(2, '2024-05-02', 515.00),
(1, '2024-06-01', 40.00);

-- Order Items
INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1000.00),
(1, 3, 1, 25.00),
(2, 2, 1, 500.00),
(2, 4, 1, 15.00),
(3, 4, 2, 15.00);

-- Use SELECT, WHERE, ORDER BY, GROUP BY:

SELECT country, COUNT(*) AS total_customers
FROM Customers
GROUP BY country
ORDER BY total_customers DESC;


SELECT order_id, customer_id, order_date, total_amount
FROM Orders
WHERE total_amount > 500
ORDER BY order_date DESC;

--Use JOINS (INNER, LEFT, RIGHT):

SELECT C.name, O.order_id, O.order_date, O.total_amount
FROM Customers C
INNER JOIN Orders O ON C.customer_id = O.customer_id;


SELECT C.name, O.order_id
FROM Customers C
LEFT JOIN Orders O ON C.customer_id = O.customer_id;


SELECT C.name, O.order_id
FROM Customers C
RIGHT JOIN Orders O ON C.customer_id = O.customer_id;

--Write subqueries:

SELECT name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE total_amount > (SELECT AVG(total_amount) FROM Orders)
);

--Use aggregate functions (SUM, AVG):

SELECT P.name AS product_name, SUM(OI.quantity * OI.price) AS total_revenue
FROM Products P
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY P.name
ORDER BY total_revenue DESC;


SELECT AVG(total_amount) AS avg_order_value FROM Orders;


SELECT P.category, SUM(OI.quantity) AS total_quantity
FROM Products P
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY P.category;

--Create views for analysis:

CREATE VIEW Monthly_Sales AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS monthly_revenue
FROM Orders
GROUP BY month;
SELECT * FROM Monthly_Sales;

--Optimize queries with indexes:

CREATE INDEX idx_order_date ON Orders(order_date);
CREATE INDEX idx_customer_id ON Customers(customer_id);
CREATE INDEX idx_product_id ON Order_Items(product_id);