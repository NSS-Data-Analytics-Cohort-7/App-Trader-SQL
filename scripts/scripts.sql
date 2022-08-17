--Apple Store Table
SELECT *
FROM app_store_apps;

--Google Play Table
SELECT *
FROM play_store_apps;

--Google Play App prices; I'm Rich - Trump Edition is most expensive at $400, several other 'I'm Rich' apps follow
SELECT name, CAST(price AS MONEY) AS order_price
FROM play_store_apps
GROUP BY name, price
ORDER BY order_price DESC;

--Apple Store App prices; LAMP Words For Life and Proloquo2Go (boht are ACC apps) are the highst, priced over $200
SELECT name, price
FROM app_store_apps
ORDER BY price DESC;

--Apps on Both (553) 
SELECT a.name AS Apple, p.name AS Google
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name);

--Apps on Both w/ Price (looking at the cost of each app and how they compare to each other/store)
SELECT a.name AS Apple, p.name AS Google, a.price AS apple_price, p.price AS google_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY apple_price DESC;

--Apps on Both w/ Rating 
SELECT a.name AS apple, p.name AS google, a.rating AS apple_rating, p.rating AS google_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY apple_rating DESC;

--Apps on Both w/ Content Rating
SELECT a.name AS apple, p.name AS googl, a.content_rating AS apple_contentrating, p.content_rating AS google_contentrating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY apple_contentrating DESC;



---ASOS--apple
SELECT COUNT(*)
FROM app_store_apps
WHERE name='ASOS';
--ASOS--Google
SELECT COUNT(*)
FROM play_store_apps
WHERE name='ASOS';
--ASOS--Google
SELECT COUNT(*)
FROM play_store_apps
WHERE name='Zombie Catchers';
--Zombie--Google
SELECT *
FROM play_store_apps
WHERE name='Zombie Catchers'

--Apps that are free in both 
SELECT a.name AS apple, p.name AS google, CAST(a.price AS MONEY) AS apple_price, CAST(p.price AS MONEY) AS google_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
GROUP BY apple, google, apple_price, google_price
ORDER BY apple_price;
