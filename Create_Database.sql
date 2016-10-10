#Drop database ecommerce;
create database ecommerce;

use ecommerce;

create table Shippers(
	ShipperID int(11) PRIMARY KEY,
    CompanyName nvarchar(40),
    Phone nvarchar(24)
);

create table Customers(
	CustomerID nchar(5) PRIMARY KEY,
    CompanyName nvarchar(40),
    ContactName nvarchar(30),
    ContactTitle nvarchar(30),
    Address nvarchar(60),
    City nvarchar(15),
    Region nvarchar(10),
    PostalCode nvarchar(10),
    Country nvarchar(15),
    Phone nvarchar(24),
    Fax nvarchar(24)
);

Create table Employees(
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
FOREIGN KEY (ReportsTo) REFERENCES Employees(EmployeeId)
);


create table Orders(
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
foreign key (EmployeeID) references Employees(EmployeeID),
foreign key (ShipVia) References Shippers(ShipperID),
foreign key (CustomerID) references Customers(CustomerID)
);

Create table Categories(
	CategoryID int(11) PRIMARY KEY,
    CategoryName nvarchar(15),
    Description text,
    Picture nvarchar(40)
);

create table Suppliers(
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

create table Products(
	ProductID int(11) PRIMARY KEY,
    ProductName nvarchar(40),
    SupplierID int(11),
    CategoryID int(11),
    QuantityPerUnit nvarchar(20),
    UnitPrice float,
    UnitsInStock smallint,
    UnitsOnOrder smallint,
    RecorderLevel smallint,
    Discontinued tinyint,
foreign key (SupplierID) references Suppliers(SupplierID),
foreign key (CategoryID) references Categories(CategoryID)
);

create table `Order Details`(
	odID int(10) PRIMARY KEY,
    OrderID int(11),
    ProductID int(11),
    UnitPrice float,
    Quantity smallint,
    Discount real,
foreign key (OrderID) references Orders(OrderID),
foreign key (ProductID) references Products(ProductID)
);
    

