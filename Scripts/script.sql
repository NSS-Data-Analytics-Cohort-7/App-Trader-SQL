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
order by buy_price DESC