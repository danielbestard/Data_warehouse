-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- From class

-- create a database and a table

drop database test;

show databases;

create database test;

drop table pet;
use test;

create table pet (
	name varchar(20) primary key,
	owner varchar(20),
	species varchar(20),
	sex varchar(1),
	birth date,
	death date
);


describe pet;

-- Drop table pet;

insert into pet values ('fufy','Smith','cat','f','1991-02-04',null),('Black','garcia','dog','m','1991-03-04',null);

select * from pet;

delete from pet where name="fufy"; 

update pet set death='2015-10-10' where name='Black';

select * from pet;

select name,owner from pet;



-----------------------------------------------------------------------
-----------------------------------------------------------------------



-- Integrity constraints

-- create database test;
-- use test;

drop table customer;
drop table orders;

create table customer (
customer_id varchar(5) not null,
customer_name varchar(25) not null,
address varchar(25) not null,

primary key (customer_id)
);

describe customer;

create table orders (

order_id varchar(5) not null,
order_date date not null,
customer_id varchar(5) not null,

primary key (order_id),
foreign key (customer_id) references customer(customer_id)
);

select * from customer;

-- Insert value into customer 

insert into customer values 
('1','guglielmo','rambla catalunya 93884'),
('2','jordi','ronda universidad 9'),
('3','ana','carrer catalunya 93884');

delete from customer where customer_id='2';

insert into customer values 
('1','jordi','ronda universidad 9');

-- I'm duplicating entry '1' for the primary key and that by my own integruty constraints can't be done!

insert into customer values 
('2','jordi','ronda universidad 9');

-- insert values into orders 

Insert into orders values ('1','2014-09-27','1'),('2','2014-09-28','2');

select * from customer;
select * from orders;

delete from customer where customer_id='1';

-- you can't do that cause by your own constraints that is restricted. you would leave an order without a customer issuing it

delete from customer where customer_id='2';

-- try with customer 3

delete from customer where customer_id='3';

-- No problem with that, couse customer '3' did not have any order
-- Now let's say an order arrives from the gost of customer '3'

Insert into orders values ('3','2014-03-14','3');

-- The DBMS rejects it
-- this order would be issued by no one


-- if you like to live dangerously you can go this way (allow delete on cascade)

drop table orders;
 
create table orders (

order_id varchar(5) not null,
order_date date not null,
customer_id varchar(5) not null,

primary key (order_id),
foreign key (customer_id) references customer(customer_id) on delete cascade
);

Insert into orders values ('1','2014-09-27','1'),('2','2014-09-28','2');

delete from customer where customer_id='1';

select * from customer;

select * from orders;

-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- Alter a table
-- Before I create Album and after I'll create  Artist

Drop table Album;

create table Album (
AlbumId int not null,
Title varchar (160) not null,
ArtistId int not null,
primary key (Albumid)
);

Create table Artist (
ArtistId int not null,
Name varchar(120),
primary key (ArtistId)
);

drop table Artist; 
Drop table Album;

create table Album (
AlbumId int not null,
Title varchar (160) not null,
ArtistId int not null,
primary key (Albumid),
foreign key (ArtistId) references Artist (ArtistId) 
);


-- An alternative would have been...

drop table Artist; 
Drop table Album;

create table Album (
AlbumId int not null,
Title varchar (160) not null,
ArtistId int not null,
primary key (Albumid)
);

Create table Artist (
ArtistId int not null,
Name varchar(120),
primary key (ArtistId)
);

alter table Album add constraint 
foreign key (ArtistId) references Artist (ArtistId) on delete no action on update no action;

-- end of file