-- Drop tables in reverse dependency order
BEGIN EXECUTE IMMEDIATE 'DROP TABLE orderdetails CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE orders CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE employees CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE products CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE productlines CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE offices CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Create offices
CREATE TABLE offices (
  officeCode VARCHAR2(10) PRIMARY KEY,
  city VARCHAR2(50),
  phone VARCHAR2(50),
  addressLine1 VARCHAR2(50),
  addressLine2 VARCHAR2(50),
  state VARCHAR2(50),
  country VARCHAR2(50),
  postalCode VARCHAR2(15),
  territory VARCHAR2(10)
);

-- Create employees
CREATE TABLE employees (
  employeeNumber NUMBER PRIMARY KEY,
  lastName VARCHAR2(50),
  firstName VARCHAR2(50),
  extension VARCHAR2(10),
  email VARCHAR2(100),
  officeCode VARCHAR2(10),
  reportsTo NUMBER,
  jobTitle VARCHAR2(50),
  CONSTRAINT fk_employees_office FOREIGN KEY (officeCode) REFERENCES offices(officeCode),
  CONSTRAINT fk_employees_manager FOREIGN KEY (reportsTo) REFERENCES employees(employeeNumber)
);

-- Create customers
CREATE TABLE customers (
  customerNumber NUMBER PRIMARY KEY,
  customerName VARCHAR2(50),
  contactLastName VARCHAR2(50),
  contactFirstName VARCHAR2(50),
  phone VARCHAR2(50),
  addressLine1 VARCHAR2(50),
  addressLine2 VARCHAR2(50),
  city VARCHAR2(50),
  state VARCHAR2(50),
  postalCode VARCHAR2(15),
  country VARCHAR2(50),
  salesRepEmployeeNumber NUMBER,
  creditLimit NUMBER(10,2),
  CONSTRAINT fk_customers_salesrep FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employees(employeeNumber)
);

-- Create orders
CREATE TABLE orders (
  orderNumber NUMBER PRIMARY KEY,
  orderDate DATE,
  requiredDate DATE,
  shippedDate DATE,
  status VARCHAR2(15),
  comments CLOB,
  customerNumber NUMBER,
  CONSTRAINT fk_orders_customer FOREIGN KEY (customerNumber) REFERENCES customers(customerNumber)
);

-- Create productlines
CREATE TABLE productlines (
  productLine VARCHAR2(50) PRIMARY KEY,
  textDescription VARCHAR2(4000),
  htmlDescription CLOB,
  image BLOB
);

-- Create products
CREATE TABLE products (
  productCode VARCHAR2(15) PRIMARY KEY,
  productName VARCHAR2(70),
  productLine VARCHAR2(50),
  productScale VARCHAR2(10),
  productVendor VARCHAR2(50),
  productDescription CLOB,
  quantityInStock NUMBER(5),
  buyPrice NUMBER(10, 2),
  MSRP NUMBER(10, 2),
  CONSTRAINT fk_products_line FOREIGN KEY (productLine) REFERENCES productlines(productLine)
);

-- Create orderdetails
CREATE TABLE orderdetails (
  orderNumber NUMBER,
  productCode VARCHAR2(15),
  quantityOrdered NUMBER,
  priceEach NUMBER(10, 2),
  orderLineNumber NUMBER(5),
  PRIMARY KEY (orderNumber, productCode),
  CONSTRAINT fk_orderdetails_order FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber),
  CONSTRAINT fk_orderdetails_product FOREIGN KEY (productCode) REFERENCES products(productCode)
);
