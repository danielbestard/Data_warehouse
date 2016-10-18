-- -----------------------------------------------------------------------
-- -----------------------------------------------------------------------
-- From class n.3 --------------------------------------------------------

-- Lets start some data exploration 

select * from order_details limit 10;
select * from orders limit 10;

---------------------------------------------------------------------------
-- Let's look at the time window
select min(orderdate) as first_order, max(orderdate) as last_order
from orders;

select count(*) as total_orders from ecommerce.orders where year(orderdate)=1996;

select sum(quantity) as total_products_sold from order_details;

-------------------------------------------------------------------------

drop database BI;

create database BI;
use BI;

drop table BI.step1;

create table BI.step1 as 
select employeeID, count(OrderID) as orders_placed
from ecommerce.orders
where OrderDate>='1996-01-01' and orderdate<'1997-01-01'
group by employeeID;

-- try what happen if you forget the group by clause 

select * from step1;

create table BI.step2 as 
select employeeID, orders_placed, 
case 
when orders_placed < 15 then '3.Low performance'
when orders_placed >15 and orders_placed < 20 then '2.Medium performance'
else '1.High performance'
end as performance

from BI.step1
order by performance;

select * from step2;

-------------------------------------------------------------------------------

-- I could have done that in just one step

create table BI.emploees_performance as
	select employeeID, orders_placed, 
		case 
			when orders_placed < 15 then '3.Low performance'
			when orders_placed >15 and orders_placed < 20 then '2.Medium performance'
			else '1.High performance'
		end as performance
	from (select employeeID, count(OrderID) as orders_placed from ecommerce.orders
		where OrderDate>='1996-01-01' and orderdate<'1997-01-01' group by employeeID) willy
order by performance;


select * from emploees_performance;

----------------------------------------------------------------------------------

-- -----------------------------------------------------
-- -----------------------------------------------------

-- Now we know how to work with many tables

-- We want to know the top 10 best seller products for 1997!!!

drop table best_seller1;

create table best_seller1 as 
select productid, quantity, orderdate
from ecommerce.order_details, ecommerce.orders
where order_details.orderID=orders.orderID
;

select * from best_seller1;

create table best_seller2 as 
select products.productid,quantity, productname
from ecommerce.order_details, ecommerce.products
where order_details.ProductID=products.ProductID;


select * from best_seller2;

create table best_seller3 as
select productname, quantity, orderdate

from (select orderID, quantity, products.productid, productname from ecommerce.order_details, ecommerce.products
where order_details.ProductID=products.ProductID) best_seller2,

ecommerce.orders

where best_seller2.orderID=orders.orderID
;


select * from best_seller3;

-------------------------------------------------------------------------------------
--------------------------------------------------------------------------
-- ------------------------------------------------------------------------- 
-- So let's find the top 10 best seller products for 1997!!!


drop table best_seller4;

create table best_seller4 as
select productname, sum(quantity) as total_sales, min(orderdate) as first_sale, max(orderdate) as last_sale

from (select orderID, quantity, products.productid, productname from ecommerce.order_details, ecommerce.products
where order_details.ProductID=products.ProductID) best_seller2,

ecommerce.orders
where best_seller2.orderID=orders.orderID and year(orderdate)=1997
group by productname
order by total_sales desc
limit 10
;


select * from best_seller4;

-----------------------------------------EoC------------------------------------------------