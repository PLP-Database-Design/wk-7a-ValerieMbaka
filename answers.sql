-- Question 1: Achieving First Normal Form
-- Create original table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert data
INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Transform into 1NF
SELECT
    OrderID,
    CustomerName,
    TRIM(product.value) AS Product
FROM ProductDetail,
JSON_TABLE(
    CONCAT('["', REPLACE(Products, ',', '","'), '"]'),
    '$[*]' COLUMNS (value VARCHAR(100) PATH '$')
) AS product;



-- Question 2: Achieving Second Normal Form
-- Create and populate the original OrderDetails table
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity)
VALUES
    (101, 'John Doe', 'Laptop', 2),
    (101, 'John Doe', 'Mouse', 1),
    (102, 'Jane Smith', 'Tablet', 3),
    (102, 'Jane Smith', 'Keyboard', 1),
    (102, 'Jane Smith', 'Mouse', 2),
    (103, 'Emily Clark', 'Phone', 1);

-- Create CustomerOrders table
CREATE TABLE CustomerOrders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Populate it with unique OrderID–CustomerName pairs
INSERT INTO CustomerOrders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create OrderProducts table
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES CustomerOrders(OrderID)
);

-- Populate OrderProducts
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
