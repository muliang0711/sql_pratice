DROP DATABASE IF EXISTS practicaldb;
CREATE DATABASE practicaldb;
USE practicaldb;

-- Drop tables in reverse FK dependency order
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS productlines;
DROP TABLE IF EXISTS offices;

-- Create offices first
CREATE TABLE offices (
  officeCode VARCHAR(10) PRIMARY KEY,
  city VARCHAR(50),
  phone VARCHAR(50),
  addressLine1 VARCHAR(50),
  addressLine2 VARCHAR(50),
  state VARCHAR(50),
  country VARCHAR(50),
  postalCode VARCHAR(15),
  territory VARCHAR(10)
);

-- Then employees (self-referencing + references offices)
CREATE TABLE employees (
  employeeNumber INT PRIMARY KEY,
  lastName VARCHAR(50),
  firstName VARCHAR(50),
  extension VARCHAR(10),
  email VARCHAR(100),
  officeCode VARCHAR(10),
  reportsTo INT,
  jobTitle VARCHAR(50),
  FOREIGN KEY (officeCode) REFERENCES offices(officeCode),
  FOREIGN KEY (reportsTo) REFERENCES employees(employeeNumber)
);

-- Then customers (references employees)
CREATE TABLE customers (
  customerNumber INT PRIMARY KEY,
  customerName VARCHAR(50),
  contactLastName VARCHAR(50),
  contactFirstName VARCHAR(50),
  phone VARCHAR(50),
  addressLine1 VARCHAR(50),
  addressLine2 VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50),
  postalCode VARCHAR(15),
  country VARCHAR(50),
  salesRepEmployeeNumber INT,
  creditLimit DOUBLE,
  FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employees(employeeNumber)
);

-- Then orders (references customers)
CREATE TABLE orders (
  orderNumber INT PRIMARY KEY,
  orderDate DATETIME,
  requiredDate DATETIME,
  shippedDate DATETIME,
  status VARCHAR(15),
  comments TEXT,
  customerNumber INT,
  FOREIGN KEY (customerNumber) REFERENCES customers(customerNumber)
);

-- Then productlines (no dependency)
CREATE TABLE productlines (
  productLine VARCHAR(50) PRIMARY KEY,
  textDescription VARCHAR(4000),
  htmlDescription MEDIUMTEXT,
  image MEDIUMBLOB
);

-- Then products (references productlines)
CREATE TABLE products (
  productCode VARCHAR(15) PRIMARY KEY,
  productName VARCHAR(70),
  productLine VARCHAR(50),
  productScale VARCHAR(10),
  productVendor VARCHAR(50),
  productDescription TEXT,
  quantityInStock SMALLINT,
  buyPrice DOUBLE,
  MSRP DOUBLE,
  FOREIGN KEY (productLine) REFERENCES productlines(productLine)
);

-- Finally orderdetails (references orders + products)
CREATE TABLE orderdetails (
  orderNumber INT,
  productCode VARCHAR(15),
  quantityOrdered INT,
  priceEach DOUBLE,
  orderLineNumber SMALLINT,
  PRIMARY KEY (orderNumber, productCode),
  FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber),
  FOREIGN KEY (productCode) REFERENCES products(productCode)
);
