
-- 1.a
select employeenumber,lastName,firstname from employees where jobtitle="sales rep" and reportsTo=1102;


-- 1.b
select  distinct productline from products where productline like "%cars";
select * from customers;

-- 2 
select customernumber,customername, -- using the case statment
CASE
when country in("usa","canada") then "North America"
when country in("uk","Germany","france") then "Europe"
else "others" 
end as "customerSegment"
from customers;

-- 3.a
select productcode,sum(quantityOrdered) as total_ordered from orderdetails group by productcode order by total_ordered desc limit 10 ;

-- 3.b
SELECT 
    MONTHNAME(paymentDate) AS month_name,
    COUNT(*) AS total_payments
FROM 
    Payments
GROUP BY 
    MONTH(paymentDate), MONTHNAME(paymentDate)
HAVING 
    total_payments > 20
ORDER BY 
    total_payments DESC;
    
    -- 4 creation of table 
    
create table Customerss(Customer_id int primary key auto_increment, first_name varchar(50) not null, last_name varchar(50) not null,
      email varchar(255) not null, phone_number varchar(20)); 
desc Customerss;

-- 4 .b creation of child table 

create table Orderss(Order_id int primary key auto_increment, customer_id int, order_date date,total_amount decimal(10,2),
 foreign key(customer_id) references customerss(customer_id), check(total_amount>0));

desc orderss;


-- 5 joins 

select country,count(orderNumber) as order_count from customers join orders on customers.customerNumber=orders.customerNumber
group by country order by order_count desc limit 5;

-- 6  self-join

create table project(employeeid int primary key auto_increment, fullName varchar(50) not null, 
  gender enum("male","female"),managerid int);

insert into project values(1,"pranaya","male",3),(2,"priyanka","female",1),(3,"preety","female",null),(4,"anurag","male",1),
						  (5,"sambit","male",1),(6,"rajesh","male",3),(7,"hina","female",3);

select * from project;

SELECT 
    M.FullName AS 'Manager Name',
    E.FullName AS 'Emp Name'
FROM 
    project E
INNER JOIN 
    project M
ON 
    E.ManagerID = M.EmployeeID;

    
    
-- 7

create table facility(facility_id int, name varchar(40),state varchar(50),country varchar(40));
alter table facility modify  column facility_id int primary key auto_increment;
desc facility;
alter table facility add column city varchar(40) not null after name;

-- 8

CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine,
    ROUND(SUM(od.quantityOrdered * od.priceEach), 2) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;
    
    select * from product_category_sales;
    
    -- 9 stored procedure
    
CALL Get_country_payments(2003, 'France');


-- 10.a  rank

SELECT 
    c.customerName,
    COUNT(o.orderNumber) AS Order_count,
    DENSE_RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS order_frequency_rnk
FROM 
    Customers c
JOIN 
    Orders o ON c.customerNumber = o.customerNumber
GROUP BY 
    c.customerName
ORDER BY 
    Order_count DESC
    LIMIT 9;
    
    -- 11.b 
    
   WITH monthly_orders AS (
    SELECT 
        YEAR(orderDate) AS order_year,
        MONTH(orderDate) AS order_month,
        MONTHNAME(orderDate) AS order_month_name,
        COUNT(orderNumber) AS total_orders
    FROM 
        Orders
    GROUP BY 
        YEAR(orderDate), MONTH(orderDate), MONTHNAME(orderDate)
)

SELECT 
    order_year AS Year,
    order_month_name AS Month,
    total_orders AS `Total Orders`,
    CONCAT(
        ROUND(
            ((total_orders - LAG(total_orders) OVER (PARTITION BY order_year ORDER BY order_month)) * 100.0)
            / NULLIF(LAG(total_orders) OVER (PARTITION BY order_year ORDER BY order_month), 0), 0
        ), '%'
    ) AS `% MoM Change`
FROM 
    monthly_orders
ORDER BY 
    order_year, order_month;
    
    -- 12 
     
    SELECT 
    productLine, 
    COUNT(*) AS total
FROM 
    Products
WHERE 
    buyPrice > (SELECT AVG(buyPrice) FROM Products)
GROUP BY 
    productLine
ORDER BY 
    total DESC;

-- 13 
  
  CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

CALL InsertIntoEmpEH(1, 'Alice', 'alice@example.com');
CALL InsertIntoEmpEH(1, 'bob', 'alice@example.com');

-- 13  

CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

DELIMITER $$

CREATE TRIGGER before_insert_EmpBIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END $$

DELIMITER ;

INSERT INTO Emp_BIT VALUES ('TestUser', 'Tester', '2025-04-25', -8);

-- Check the result
SELECT * FROM Emp_BIT WHERE Name = 'TestUser';

select * from Emp_BIT;














