
-- -----------------------------------------------------------------------


--------------------------------------------------------------------------
-- ------------------------------------------------------------------------- 
-- So let's find the top 10 best seller products for 1997!!!

drop table best_sellers2;
create table best_sellers2 as

select a.ProductName,sum(a.Quantity) as total_number,min(orders.OrderDate) as firt_sale,max(orders.OrderDate) as last_sale

	from (select order_details.OrderID,order_details.Quantity,products.ProductName
			from order_details, products where order_details.ProductID=products.ProductID) a,
orders

where a.OrderID=orders.OrderID and year(orders.OrderDate)=1997
group by a.productName
order by total_number desc
limit 10;

---------------------------------------------------------------------------
select * from best_sellers2;
---------------------------------------------------------------------------


-- let's clean it up a bit

create table BI.best_sellers_view as 
	select 
		b.ProductName,
		sum(a.Quantity) as total_sale, 
		min(c.OrderDate) as first_sale, 
		max(c.OrderDate) as last_sale 
	from 
			order_details a, 
			products b,
			orders c
	where a.OrderID=c.OrderID and a.productid=b.ProductID and year (OrderDate) =1997 
	group by ProductName
	order by total_sale desc
limit 10;

--  or again

create table BI.best_sellers_final as ;
	select 
		b.ProductName,
		sum(a.Quantity) as total_sale, 
		min(c.OrderDate) as first_sale, 
		max(c.OrderDate) as last_sale 
	from order_details a
		left join products b
		on a.productid=b.ProductID
			left join orders c
			on a.OrderID=c.OrderID 
		where year (OrderDate) =1997 
	group by ProductName
	order by total_sale desc
limit 10;

-- I want to tranform it into a view

use ecommerce;

drop table best_sellers2;

create view best_sellers_1997_top10 as
 
select a.ProductName,sum(a.Quantity) as total_number,min(orders.OrderDate) as first_sale, max(orders.OrderDate) as last_sale

	from (select order_details.OrderID,order_details.Quantity,products.ProductName
			from order_details, products where order_details.ProductID=products.ProductID) a,
orders

where a.OrderID=orders.OrderID and year(orders.OrderDate)=1997
group by a.productName
order by total_number desc
limit 10;

---------------------------------------------------------------------------
select * from best_sellers2;

-- It doesn't work cause mysql views don't allow sub-queries!!!!
-- let's modify the code so it does not contain a sub-query

drop view best_sellers_1997_top10;

create view best_sellers_1997_top10 as

select a.ProductName,
sum(b.Quantity) as total_number,
min(c.OrderDate) as firt_sale,
max(c.OrderDate) as last_sale

from order_details b 
	left join products a
		on b.ProductID=a.ProductID
			left join orders c
			on b.OrderID=c.OrderID

			where year(c.OrderDate)=1997
		group by a.productName
	order by total_number desc
limit 10;

select * from best_sellers_1997_top10;

-- now it works !!!
-- let's make this query a standard procedure so we will have it always available

DELIMITER $$
create procedure getbestsellers (
 
yearofinterest int(4),
number_rank int (10)
)
BEGIN
select a.ProductName,
sum(b.Quantity) as total_number,
min(c.OrderDate) as firt_sale,
max(c.OrderDate) as last_sale

from order_details b 
	left join products a
		on b.ProductID=a.ProductID
			left join orders c
			on b.OrderID=c.OrderID
			
			where year(c.OrderDate)=yearofinterest
		group by a.productName
	order by total_number desc
limit number_rank;

end$$
DELIMITER ;
-- -------------------------------------------------------------------------

call getbestsellers (1997,10);
call getbestsellers (1996,5);
call getbestsellers (1998,3);

set @year= 1997;
set @rank= 10;

call getbestsellers (@year,@rank);


 
 
 
