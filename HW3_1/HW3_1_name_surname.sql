
-- Problem set week 3

-- Please add the proper SQL query to follow the instructions below  

-- 1) Select ecommerce as your default database 

use ecommerce;

-- 2) Show the PK, name, and quantity per unit from all products in stock

select ProductID, ProductName, QuantityPerUnit 
from products;

-- 3) Show the number of products ever on sale in our stores

select count(ProductID) 
from products;

-- 4) Show the number of products in stock (available right now) in our store

select count(ProductID) 
from products 
where UnitsInStock>0;

--  5) Show the number of products with more orders than stock

select count(ProductID) 
from products 
where UnitsOnOrder>UnitsInStock;

-- 6) List all products available in the store and order them alphabetically from a to z 
-- Show just the first ten products 

select ProductName 
from products 
where UnitsInStock>0 
order by ProductName asc;

--  7) Create a new table in a separated schema. Call it Products2 with the same content of table products

create database tempDB;

use tempDB;

create table Products2 as
select * from ecommerce.products;

--  8) Delete the previously created table

drop table Products2;

--  9) Show how many customer the store has from Mexico

use ecommerce;

select count(CustomerID) 
from customers 
where Country='Mexico';

-- 10) Show how many different countries our customers come from

select count(distinct(Country)) 
from customers;

--  11) Define a new table and call it ReportAlpha 
--  Show all fields from table "categories"
--  Add a field FullName as the concatenation of Category Name and Description
--  if field Picture is NULL Replace it by the 'NULL' string, and
--  if field Picture is the empty string replace it by 'No picture'
--  (hint: use the CONCAT function and the CASE WHEN statement)

create table ReportAlpha as
select CategoryID, CategoryName, Description,  
concat(CategoryName,Description) as FullName,
case
when isnull(Picture) then 'NULL'
when Picture='' then 'No picture'
else Picture
end as Picture
from categories;

--  12) Show how many customers are from Mexico, Argentina, or Brazil 
--  whose contact title is  Sales Representative or a Sales Manager

select count(CustomerID) 
from customers 
where Country IN ('Mexico', 'Argentina', 'Brazil')
and ContactTitle in ('Sales Representative','Sales Manager');

--  13) Show the number of employees that are 50 years old or more 
--  as at 2014-10-06 (you will probably need to use the DATE_FORMAT function) 

select count(EmployeeID) from employees where TIMESTAMPDIFF(YEAR, date_format(BirthDate,'%Y-%m-%d'), '2014-10-06')>50;

--  14) Show the age of the oldest employee of the company
--  (hint: use the YEAR and DATE_FORMAT functions)

select max(TIMESTAMPDIFF(YEAR, date_format(BirthDate,'%Y-%m-%d'), current_date())) from employees;

--  15) Show the number of products whose quantity per unit is measured in bottles

select count(ProductID) from products where QuantityPerUnit like "%bottles%";

-- 16) Show the number of customers with a Spanish or British common surname
--  (a surname that ends with -on or -ez)

select count(CustomerID) from customers where ContactName like '%on' or ContactName like '%ez';

--  17) Show how many distinct countries our 
--  customers with a Spanish or British common surname come from
--  (a surname that ends with -on or -ez)

select count(distinct(Country)) from customers where ContactName like '%on' or ContactName like '%ez';


--  18) Show the number of products whose names do not contain the letter 'a'
--  (Note: patterns are not case sensitive)

select count(ProductID) from products where ProductName not like '%a%';

--  19) Get the total number of single items sold ever

select count(num) from (select count(odID) as num from order_details group by OrderID) where num=1;

select count(OrderID) from order_details where (select count(odID) from order_details group by OrderID);

--  20) Get the id of all products sold at least one time

select distinct(ProductID) from order_details where Quantity>=1;

--  21) Is there any product that was never sold?

--  22) Get the list of products sorted by category on the following way:
--  2,4,6,7,3,1,5,8
--  i.e. first all products of category 2, then all products of 
--  category 4, and so on.
--  Sort alphabetically by ProductName inside one category (hint: use CASE WHEN)

;



---------------------------------EoC---------------------------------------------