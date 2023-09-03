use sqlproject;
select * from `icc test batting figures (1)`;


-- 2.	Remove the column 'Player Profile' from the table.
alter table `icc test batting figures (1)`
drop column `Player Profile`;
select * from `icc test batting figures (1)`;


-- 3.Extract the country name and player names from the given data and store it in separate columns for further usage.
ALTER TABLE `icc test batting figures (1)` ADD COLUMN country VARCHAR(50);
ALTER TABLE `icc test batting figures (1)` ADD COLUMN player_name VARCHAR(50);
UPDATE `icc test batting figures (1)` SET country = SUBSTRING_INDEX(SUBSTRING_INDEX(player, '(', -1), ')', 1);
UPDATE `icc test batting figures (1)` SET player_name = TRIM(SUBSTRING_INDEX(player, '(', 1));


-- 4.	From the column 'Span' extract the start_year and end_year and store them in separate columns for further usage.
ALTER TABLE `icc test batting figures (1)` ADD COLUMN start_year varchar(10);
ALTER TABLE `icc test batting figures (1)` ADD COLUMN end_year varchar(10);
UPDATE `icc test batting figures (1)` SET start_year = substring(span,1,4);
UPDATE `icc test batting figures (1)` SET end_year = substring(span,6,9);
select *
from `icc test batting figures (1)`;


-- 5.	The column 'HS' has the highest score scored by the player so far in any given match. The column also has details 
-- if the player had completed the match in a NOT OUT status.
-- Extract the data and store the highest runs and the NOT OUT status in different columns.
alter table `icc test batting figures (1)` add column hs_notout varchar(5);
update `icc test batting figures (1)` 
set hs_notout = hs
where hs like '%*';


-- 6.	Using the data given, considering the players who were active in the year of 2019,
-- create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.

select player , `Avg` 
from `icc test batting figures (1)`
where cast(end_year as unsigned) < 2019 and country like '%ind%'
order by `Avg` desc
limit 6 ;

-- 7. Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players 
-- using the selection criteria of those who have the highest number of 100s across all matches for India.

select * 
from `icc test batting figures (1)`;
select player, `100`
from `icc test batting figures (1)`
where cast(end_year as unsigned) < 2019 and country like '%ind%' 
order by `100` desc
limit 6;

-- 8.Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using 2 selection criteria of your own for India.
select * 
from `icc test batting figures (1)`;
select player, Mat, `Avg`,`NO`
from `icc test batting figures (1)`
where cast(end_year as unsigned) < 2019 and country like '%ind%' 
order by mat desc,`Avg` desc,`NO`
limit 6;


-- 9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active in the year of 2019,
-- create a set of batting order of best 6 players using the 
-- selection criteria of those who have a good average score across all matches for South Africa

create view Batting_Order_GoodAvgScorers_SA as select player ,`Avg`
from `icc test batting figures (1)`
where cast(end_year as unsigned) < 2019 and country like '%SA%' 
order by `Avg` desc
limit 6;

-- 10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active in the year of 2019,
-- create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.
create view Batting_Order_HighestCenturyScorers_SA as select player ,`Avg`
from `icc test batting figures (1)`
where cast(end_year as unsigned) < 2019 and country like '%SA%' 
order by `100` desc
limit 6;


-- 11.	Using the data given, Give the number of player_played for each country.
select country, count(player) count_of_players
from `icc test batting figures (1)`
group by country;

-- 12.	Using the data given, Give the number of player_played for Asian and Non-Asian continent
select case
when country in ('INDIA','ICC/INDIA','PAK','SL','BDESH') THEN 'ASIAN'
ELSE 'NON-ASIAN'
END AS CONTINENT,
COUNT(*) AS NO_PLAYER
from `icc test batting figures (1)` group by CONTINENT;


use supply_chain;
-- 1.Company sells the product at different discounted rates. Refer actual product price in product table and selling price in the order item table.
-- Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved. 
select  distinct o.id,productname, sum(p.unitprice - oi.unitprice) profit_price
from orderitem oi join product p
on p.id=oi.productid join orders o
on o.id=oi.orderid
group by o.id,productname
order by profit_price desc;

-- 2.	Mr. Kavin want to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
-- a. List few products that he should choose based on demand.
-- b. Who will be the competitors for him for the products suggested in above questions.
select ProductName , count(o2.id) 
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid
group by ProductName;

select ProductName , count(o2.id) 
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid
group by ProductName;

select ProductName , count(o2.id) , CompanyName
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid join 
supplier s on s.id = p.SupplierId
group by ProductName,CompanyName;


-- 3.	Create a combined list to display customers and suppliers details considering the following criteria 
-- ●	Both customer and supplier belong to the same country
-- ●	Customer who does not have supplier in their country
-- ●	Supplier who does not have customer in their country

select firstname  , CompanyName
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid join 
supplier s on s.id = p.SupplierId join customer c
on c.id = o2.customerid
where c.country=s.country;

select distinct firstname  
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid right join 
supplier s on s.id = p.SupplierId join customer c
on c.id = o2.customerid
where c.country not in (select country from supplier );


select distinct companyname  
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid join 
supplier s on s.id = p.SupplierId join customer c
on c.id = o2.customerid
where s.country not in (select country from customer );

-- 4.	Every supplier supplies specific products to the customers. Create a view of suppliers and total sales made by their products and 
-- write a query on this view to find out top 2 suppliers (using windows function) in each country by total sales done by the products.
create view supplier_sales as 
select companyname,country,sum(od.UnitPrice*Quantity) total_sales from supplier s join product p
on  p.supplierid=s.id join orderitem od on
od.ProductId=p.id
group by companyname,country;

select * from (select * , rank()over(partition by country order by total_sales) rnk  from supplier_sales)t
where rnk<3;
-- 5.	Find out for which products, UK is dependent on other countries for the supply.
-- List the countries which are supplying these products in the same list

select productname, s.country as supply_country 
from product p join orderitem o 
on p.id=o.ProductId join orders o2
on o2.id=o.orderid join 
supplier s on s.id = p.SupplierId join customer c
on c.id = o2.customerid
where c.country = 'UK' and s.country!='UK' ;


-- Create the customer table
CREATE TABLE customer1 (
  Id INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Phone VARCHAR(20)
);

-- Create the customer_backup table
CREATE TABLE customer_backup (
  Id INT,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Phone VARCHAR(20)
);
use supply_chain;
-- Create the trigger
CREATE TRIGGER customer_delete_trigger
AFTER DELETE ON customer1

FOR EACH ROW
  INSERT INTO customer_backup (Id, FirstName, LastName, Phone)
  VALUES (OLD.Id, 
  OLD.FirstName, OLD.LastName, OLD.Phone);
