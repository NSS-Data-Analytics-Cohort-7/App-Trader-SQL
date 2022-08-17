Select *
From play_store_apps AS p
Left Join app_store_apps AS a
ON p.name= a.name
Order by a.name, p.name 

Select Distinct(name)
From app_store_apps
Inner Join play_store_apps
Using(name)

Select name, Cast(price AS MONEY) AS order_price
FROM play_store_apps
Group By name, price
Order by order_price Desc

Select name, Cast(price AS MONEY) AS order_price
FROM app_store_apps
Group By name, price
Order by order_price Desc

Select p.name, p.rating, a.rating, a.price, p.price, a.primary_genre, p.genres
From play_store_apps AS p
Join app_store_apps AS a
ON p.name= a.name
Group By p.name, p.rating, a.rating, a.price, p.price, a.primary_genre, p.genres
Order by a.rating DESC, p.rating DESC
Limit 20


