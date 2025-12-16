create database AirBnb;
use AirBnb;

# Imported the csv into sqlworkbench using python
show tables;

#display the imported data
select * from combined_listings limit 5;

# top 10 expensive listings
select city, property_type, price from combined_listings order by price desc limit 10;

# Average price per city
select city, round(avg(price),2) as avg_price from combined_listings group by city order by avg_price desc;

# Average reviews per property type
select property_type, round(avg(number_of_reviews),2) as avg_reviews from combined_listings group by property_type order by avg_reviews desc;

#Joins (self)
select a.host_id, a.city, b.city as other_city from combined_listings a join combined_listings b on a.host_id = b.host_id and a.city <> b.city;
       
# subqueries
select id, city, price from combined_listings where price > (select avg(price) from combined_listings);

# Stored procedure
drop procedure if exists gettopcities;
delimiter //
 create procedure gettopcities()
    begin
        select city, round(avg(price),2) as avg_price, count(id) as listings
        from combined_listings
        group by city
        order by avg_price desc
        limit 5;
    end;
delimiter ;

CALL gettopcities();

# trigger 
drop trigger if exists before_insert_price_check;
delimiter //
 create trigger before_insert_price_check
    before insert on combined_listings
    for each row
    set new.price = if(new.price < 0, 0, new.price);
delimiter ;

