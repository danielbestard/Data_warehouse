
-- Problem set week 3 number 2.

-- Please load music-store database

-- Please add the proper SQL query to follow the instructions below


------------------------------------------------
use musicstore;
------------------------------------------------

-- 1.Show the Number of tracks whose composer is F. Baltes
-- (Note: there can be more than one composers or each track)

Select count(TrackId) 
from Track 
where Composer like "%F. Baltes%";

-- 2.Show the Number of invoices, and the number of invoices with a total amount =0

select count(InvoiceId) from Invoice
UNION
select count(InvoiceId) from Invoice where Total=0;

-- 3.Show the album title and artist name of the first five albums sorted alphabetically

select Album.Title, Artist.Name 
from Album Left join Artist on Album.ArtistId=Artist.ArtistId
order by Album.Title ASC limit 5;  

-- 4.Show the Id, first name, and last name of the 10 first customers 
-- alphabetically ordered. Include the id, first name and last name 
-- of their support representative (employee)
 
select Customer.CustomerId, Customer.FirstName as CustomerFirstName, 
Customer.LastName as CustomerLastName, Employee.EmployeeId, 
Employee.FirstName as RepFirstName, Employee.LastName as RepLastName 
from Customer 
inner join 
Employee 
on Employee.EmployeeId=Customer.SupportRepId
order by Customer.FirstName ASC limit 10;

-- 5.Show the Track name, duration, album title, artist name,
--  media name, and genre name for the five longest tracks

select Track.Name, Track.Milliseconds, temp.Title, temp.Name 
from Track 
inner join (
	select Album.AlbumId, Album.Title, Artist.Name 
	from Album inner join Artist 
    on Artist.ArtistId=Album.ArtistId) temp 
order by Track.Milliseconds Desc limit 5;

-- 6.Show Employees' first name and last name
-- together with their supervisor's first name and last name
-- Sort the result by employee last name

select Employee.FirstName, Employee.LastName, supervisor.FirstName, supervisor.LastName
from Employee 
Left join
Employee supervisor on supervisor.EmployeeId=Employee.ReportsTo
order by Employee.LastName;

-- 7.Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
--  together with the average price per track

select Album.Title, temp.price/temp.num as Average
from Album inner join (
	select Track.AlbumId, sum(Track.UnitPrice) as price, count(Track.TrackId) as num 
	from Track Group by Track.AlbumId) temp 
    on temp.AlbumId=Album.AlbumId 
Order by temp.price DESC limit 5;

-- 8. Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
-- but only if the average price per track is above 1

select Album.Title, temp.price/temp.num as Average
from Album inner join (
	select Track.AlbumId, sum(Track.UnitPrice) as price, count(Track.TrackId) as num 
	from Track Group by Track.AlbumId) temp on temp.AlbumId=Album.AlbumId 
Where temp.price/temp.num>1
Order by temp.price DESC limit 5;


-- 9.Show the album Id and number of different genres
-- for those albums with more than one genre
-- (tracks contained in an album must be from at least two different genres)
-- Show the result sorted by the number of different genres from the most to the least eclectic 

select Album.AlbumId, temp.Num as NumberGenres 
from Album inner join (
	select Track.AlbumId, count(distinct(Track.GenreId)) as Num 
	from Track group by AlbumId) temp on temp.AlbumId=Album.AlbumId
where temp.num>1 
order by temp.num Desc;

-- 10.Show the total number of albums that you get from the previous result (hint: use a nested query)

Select count(AlbumId) from (
	select Album.AlbumId, temp.Num as NumberGenres 
	from Album inner join (
		select Track.AlbumId, count(distinct(Track.GenreId)) as Num 
		from Track group by AlbumId) temp on temp.AlbumId=Album.AlbumId
	where temp.num>1 
	order by temp.num Desc) NumGenres;


-- 11.Show the	number of tracks that were ever in some invoice

select count(distinct(InvoiceLine.TrackId)) 
from InvoiceLine;

-- 12.Show the Customer id and total amount of money billed to the five best customers 
-- (Those with the highest cumulated billed imports)

select Invoice.CustomerId, sum(Invoice.Total) as Billed 
from Invoice group by Invoice.CustomerId order by Billed DESC limit 5;


-- 13.Add the customer's first name and last name to the previous result
-- (hint:use a nested query)

select temp.CustomerId, Customer.FirstName, Customer.LastName, temp.Billed 
from (
	select Invoice.CustomerId, sum(Invoice.Total) as Billed 
	from Invoice group by Invoice.CustomerId order by Billed DESC limit 5) temp 
left join 
	Customer on Customer.CustomerId=temp.CustomerId;


-- 14.Check that the total amount of money in each invoice
-- is equal to the sum of unit price x quantity
-- of its invoice lines.

select Invoice.InvoiceId, Invoice.Total, temp.TotalLine, Invoice.Total=temp.TotalLine as CheckTot 
from Invoice Inner join (
	Select InvoiceLine.InvoiceId, sum(InvoiceLine.Quantity*InvoiceLine.UnitPrice) as TotalLine 
	from InvoiceLine group by InvoiceLine.InvoiceId) temp 
on temp.InvoiceId=Invoice.InvoiceId;

-- 15.We are interested in those employees whose customers have generated 
-- the highest amount of invoices 
-- Show first_name, last_name, and total amount generated 

select Employee.FirstName, Employee.LastName, Rep.NumInv
from Employee left join (
	select count(Invoice.InvoiceId) NumInv, Customer.SupportRepId
		from Customer left join
			Invoice 
			on Customer.CustomerId=Invoice.CustomerId
	group by Customer.SupportRepId) Rep 
	on Rep.SupportRepId=Employee.EmployeeId
where Rep.NumInv=(select max(temp.NumInv) 
from (
	select count(Invoice.InvoiceId) NumInv
		from Customer left join
			Invoice 
			on Customer.CustomerId=Invoice.CustomerId
	group by Customer.SupportRepId) temp);

-- 16.Show the following values: Average expense per customer, average expense per invoice, 
-- and average invoices per customer.
-- Consider just active customers (customers that generated at least one invoice)

select AverageExpCust, AverageInvoices, AverageExpInvoice from (
	select avg(a.TotalCust) AverageExpCust, avg(a.NumInv) AverageInvoices from( 
		select Invoice.CustomerId, sum(Invoice.Total) TotalCust, count(Invoice.InvoiceId) NumInv
		from Invoice
		group by Invoice.CustomerId) a) b JOIN (
	select avg(Total) AverageExpInvoice from
	Invoice) c;

-- 17.We want to know the number of customers that are above the average expense level per customer. (how many?)
select count(distinct a.CustomerId) from (

	select Invoice.CustomerId, sum(Invoice.Total) TotalCust
		from Invoice
		group by Invoice.CustomerId) a
where a.TotalCust>=(select avg(b.TotalCust) from (
	select Invoice.CustomerId, sum(Invoice.Total) TotalCust
		from Invoice
		group by Invoice.CustomerId) b);


-- 18.We want to know who is the most purchased artist (considering the number of purchased tracks), 
-- who is the most profitable artist (considering the total amount of money generated).
-- and who is the most listened artist (considering purchased song minutes).
-- Show the results in 3 rows in the following format: 
-- ArtistName, Concept('Total Quantity','Total Amount','Total Time (in seconds)'), Value
-- (hint:use the UNION statement)

-- Mirar si hi ha forma mes eficient
(select Artist.Name ArtistName, c.TotPerArtist Concept from Artist 
	inner join (
		select Album.ArtistId, sum(b.TotPerAlbum) TotPerArtist from Album 
			Inner Join (
				select Track.AlbumId, sum(a.TotPerTrack) TotPerAlbum from Track 
					Inner Join (
						select InvoiceLine.TrackId, count(InvoiceLine.InvoiceLineId) TotPerTrack
							from InvoiceLine
							group by InvoiceLine.TrackId) a
					on a.TrackId=Track.TrackId
				group by Track.AlbumId) b 
			on b.AlbumId=Album.AlbumId
		group by Album.ArtistId) c
	on c.ArtistId=Artist.ArtistId
order by c.TotPerArtist Desc 
limit 1)
Union
(select Artist.Name ArtistName, c.TotPerArtist Concept from Artist 
	inner join (
		select Album.ArtistId, sum(b.TotPerAlbum) TotPerArtist from Album 
			Inner Join (
				select Track.AlbumId, sum(a.TotPerTrack) TotPerAlbum from Track 
					Inner Join (
						select InvoiceLine.TrackId, sum(InvoiceLine.UnitPrice*InvoiceLine.Quantity) TotPerTrack
							from InvoiceLine
							group by InvoiceLine.TrackId) a
					on a.TrackId=Track.TrackId
				group by Track.AlbumId) b 
			on b.AlbumId=Album.AlbumId
		group by Album.ArtistId) c
	on c.ArtistId=Artist.ArtistId
order by c.TotPerArtist Desc 
limit 1)
Union
(select Artist.Name ArtistName, c.TotPerArtist Concept from Artist 
	inner join (
		select Album.ArtistId, sum(b.TotPerAlbum) TotPerArtist from Album 
			Inner Join (
				select Track.AlbumId, sum(a.TotPerTrack*Track.Milliseconds) TotPerAlbum from Track 
					Inner Join (
						select InvoiceLine.TrackId, count(InvoiceLine.InvoiceLineId) TotPerTrack
							from InvoiceLine
							group by InvoiceLine.TrackId) a
					on a.TrackId=Track.TrackId
				group by Track.AlbumId) b 
			on b.AlbumId=Album.AlbumId
		group by Album.ArtistId) c
	on c.ArtistId=Artist.ArtistId
order by c.TotPerArtist Desc 
limit 1); 

