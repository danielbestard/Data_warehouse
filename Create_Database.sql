Drop database ecommerce;
create database ecommerce;

use ecommerce;

create table shippers(
	ShipperID int(11) PRIMARY KEY,
    CompanyName nvarchar(40),
    Phone nvarchar(24)
);

create table customers(
	CustomerID nchar(5) PRIMARY KEY,
    CompanyName nvarchar(40),
    ContactName nvarchar(30),
    ContactTitle nvarchar(30),
    Address nvarchar(60),
    City nvarchar(15),
    Region nvarchar(15),
    PostalCode nvarchar(10),
    Country nvarchar(15),
    Phone nvarchar(24),
    Fax nvarchar(24)
);

Create table employees(
	EmployeeID int(11) PRIMARY KEY,
    LastName varchar(20),
    FirstName varchar(10),
    Title varchar(30),
    TitleOfCourtesy varchar(25),
    BirthDate datetime,
    HireDate datetime,
    Address nvarchar(60),
    City nvarchar(15),
    Region nvarchar(15),
    PostalCode nvarchar(10),
    Country nvarchar(15),
    HomePhone nvarchar(24),
    Extension nvarchar(4),
    Photo nvarchar(40),
    Notes text,
    ReportsTo int,
FOREIGN KEY (ReportsTo) REFERENCES employees(EmployeeId)
);


create table orders(
	OrderID int(11) PRIMARY KEY,
    CustomerID nchar(5),
    EmployeeID int(11),
    OrderDate datetime,
    RequiredDate datetime,
    ShippedDate datetime,
    ShipVia int(11),
    Freight float,
    ShipName nvarchar(40),
    ShipAddress nvarchar(60),
    ShipCity nvarchar(15),
    ShipRegion nvarchar(15),
    ShipPostalCode nvarchar(10),
    ShipCountry nvarchar(15),
foreign key (EmployeeID) references employees(EmployeeID),
foreign key (ShipVia) References shippers(ShipperID),
foreign key (CustomerID) references customers(CustomerID)
);

Create table categories(
	CategoryID int(11) PRIMARY KEY,
    CategoryName nvarchar(15),
    Description text,
    Picture nvarchar(40)
);

create table suppliers(
	SupplierID int(11) PRIMARY KEY,
    CompanyName nvarchar(40),
    ContactName nvarchar(30),
    ContactTitle nvarchar(30),
    Address nvarchar(60),
    City nvarchar(15),
    Region nvarchar(15),
    PostalCode nvarchar(10),
    Country nvarchar(15),
    Phone nvarchar(24),
    Fax nvarchar(24),
    HomePage text
);

create table products(
	ProductID int(11) PRIMARY KEY,
    ProductName nvarchar(40),
    SupplierID int(11),
    CategoryID int(11),
    QuantityPerUnit nvarchar(20),
    UnitPrice float,
    UnitsInStock smallint,
    UnitsOnOrder smallint,
    ReorderLevel smallint,
    Discontinued tinyint,
foreign key (SupplierID) references suppliers(SupplierID),
foreign key (CategoryID) references categories(CategoryID)
);

create table `order_details`(
	odID int(10) PRIMARY KEY,
    OrderID int(11),
    ProductID int(11),
    UnitPrice float,
    Quantity smallint,
    Discount real,
foreign key (OrderID) references orders(OrderID),
foreign key (ProductID) references products(ProductID)
);
    

