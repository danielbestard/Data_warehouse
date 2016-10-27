
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


-- 3.Show the album title and artist name of the first five albums sorted alphabetically



-- 4.Show the Id, first name, and last name of the 10 first customers 
-- alphabetically ordered. Include the id, first name and last name 
-- of their support representative (employee)
 


-- 5.Show the Track name, duration, album title, artist name,
--  media name, and genre name for the five longest tracks



-- 6.Show Employees' first name and last name
-- together with their supervisor's first name and last name
-- Sort the result by employee last name



-- 7.Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
--  together with the average price per track



-- 8. Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
-- but only if the average price per track is above 1



-- 9.Show the album Id and number of different genres
-- for those albums with more than one genre
-- (tracks contained in an album must be from at least two different genres)
-- Show the result sorted by the number of different genres from the most to the least eclectic 



-- 10.Show the total number of albums that you get from the previous result (hint: use a nested query)



-- 11.Show the	number of tracks that were ever in some invoice



-- 12.Show the Customer id and total amount of money billed to the five best customers 
-- (Those with the highest cumulated billed imports)




-- 13.Add the customer's first name and last name to the previous result
-- (hint:use a nested query)



-- 14.Check that the total amount of money in each invoice
-- is equal to the sum of unit price x quantity
-- of its invoice lines.



-- 15.We are interested in those employees whose customers have generated 
-- the highest amount of invoices 
-- Show first_name, last_name, and total amount generated 



-- 16.Show the following values: Average expense per customer, average expense per invoice, 
-- and average invoices per customer.
-- Consider just active customers (customers that generated at least one invoice)



-- 17.We want to know the number of customers that are above the average expense level per customer. (how many?)


-- 18.We want to know who is the most purchased artist (considering the number of purchased tracks), 
-- who is the most profitable artist (considering the total amount of money generated).
-- and who is the most listened artist (considering purchased song minutes).
-- Show the results in 3 rows in the following format: 
-- ArtistName, Concept('Total Quantity','Total Amount','Total Time (in seconds)'), Value
-- (hint:use the UNION statement)



