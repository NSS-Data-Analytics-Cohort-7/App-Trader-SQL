SELECT * 
FROM app_store_apps

SELECT *
FROM play_store_apps
---can join on name, rating, price

SELECT * 
FROM app_store_apps
ORDER BY price DESC

---274 5.0 star ratings 
SELECT name, rating 
FROM play_store_apps
WHERE p.rating =5.0

---492 5.0 star ratings 
SELECT *
FROM app_store_apps
WHERE rating =5.0

---This gives me the TOP 10 most expensive apps with 5.0 star rating (APPLE)
SELECT name, rating, price
FROM app_store_apps
WHERE rating =5.0
ORDER BY price DESC
Limit 10


SELECT p.name, 
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, 
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating, 
MONEY(p.price) AS play_price, 
MONEY(a.price) AS app_price,
(CASE WHEN MONEY(p.price) < MONEY(1.01) THEN MONEY(10000)
ELSE MONEY(p.price) * MONEY(10000) END) AS play_purchase_price,
(CASE WHEN a.price < MONEY(1.01) THEN MONEY(10000)
ELSE a.price * MONEY(10000) END) AS app_purchase_price
FROM play_store_apps AS p
JOIN app_store_apps AS a
ON P.NAME = A.NAME 
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
ORDER BY (p.rating + a.rating) DESC
                                     

select * FROM PLAY_STORE_APPS WHERE RATING IS NOT NULL ORDER BY RATING DESC 
select * FROM App_STORE_APPS WHERE RATING IS NOT NULL ORDER BY RATING DESC 




SELECT name, rating, MONEY(price) AS order_price
FROM play_store_apps 

---corrects the order for most expensive apps in Play Store
SELECT name, MONEY(price) AS order_price
FROM play_store_apps
GROUP BY name, price
ORDER BY order_price DESC

---Distinct genres (23 primary genres)
SELECT primary_genre
FROM app_store_apps
GROUP BY primary_genre

---Distinct categories (33)
SELECT category
FROM play_store_apps
GROUP BY category

---Distinct genres (119 genres)
SELECT genres
FROM play_store_apps
GROUP BY genres

