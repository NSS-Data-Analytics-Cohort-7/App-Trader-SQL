--explorin'!
select *
from app_store_apps
order by price DESC;

Select *
from app_store_apps;

Select * 
from play_store_apps;

Select *
from play_store_apps
where price is not null and rating is not null
order by price;

Select name, CAST(price as money) as buy_price
from play_store_apps
order by buy_price DESC;

--ratings for apps in both app stores
Select a.name, a.rating, p.name, p.rating
from app_store_apps as a
Join play_store_apps as p
on a.name = p.name
Order by a.rating DESC;

Select a.name, a.rating, p.name, p.rating
from app_store_apps as a
LEFT Join play_store_apps as p
on a.name = p.name
where p.name is not null;
--553 apps both on apple and play (some appear to be duplicate apps)

--comparing the number of reviews for apps in both store. 
Select a.name as apple, Cast(a.review_count as integer) as reviewcount, p.name as play, p.review_count
from app_store_apps as a
LEFT Join play_store_apps as p
on a.name = p.name
where p.name is not null
order by a.review_count DESC;
--not ordering by desc review count accurately???? changed review count from text to integer.
