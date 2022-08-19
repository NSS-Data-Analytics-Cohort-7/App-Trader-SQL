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

--Apps that are free in both --There's 261 (292 AREN'T FREE)
SELECT a.name AS apple, p.name AS google, CAST(a.price AS MONEY) AS apple_price, CAST(p.price AS MONEY) AS google_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name) 
WHERE a.price = 0
AND a.price = 0
GROUP BY apple, google, apple_price, google_price
ORDER BY apple_price;

----Hannah's query of fun
SELECT DISTINCT p.name,
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating,
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, ---NEED TO DETERMINE LONGEVITY (has to be to the nearest '0.5')
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating,
ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) AS play_longevity_years,
ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) AS app_longevity_years,
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS play_purchase_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS app_purchase_price,
CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END AS play_investment_analysis,
CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END AS app_investment_analysis
FROM play_store_apps AS p
JOIN app_store_apps AS a  ---DOING A JOIN BECAUSE THE APP NEEDS TO BE IN BOTH TABLES
USING(name)
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
AND (CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END) NOT LIKE 'do not invest'
AND (CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END) NOT LIKE 'do not invest'
ORDER BY orig_play_rating DESC
LIMIT 10;


--Genres in both app stores 
SELECT a.name AS apple_app_name, g.name AS google_app_name, a.primary_genre AS apple_genre, g.genres AS google_genre
FROM app_store_apps AS a
JOIN play_store_apps AS g
USING (name);


----Hannah's Query of Fun w/ Genres -ok, can't get the CTE to work
WITH CTE_app_genre AS (
SELECT a.name AS apple_app_name, g.name AS google_app_name, a.primary_genre AS apple_genre, g.genres AS google_genre
FROM app_store_apps AS a
JOIN play_store_apps AS g
USING (name))







SELECT DISTINCT p.name,
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating,
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, ---NEED TO DETERMINE LONGEVITY (has to be to the nearest '0.5')
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating,
ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) AS play_longevity_years,
ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) AS app_longevity_years,
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS play_purchase_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS app_purchase_price,
CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END AS play_investment_analysis,
CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END AS app_investment_analysis
FROM play_store_apps AS p
JOIN app_store_apps AS a  ---DOING A JOIN BECAUSE THE APP NEEDS TO BE IN BOTH TABLES
USING(name)
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
AND (CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END) NOT LIKE 'do not invest'
AND (CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END) NOT LIKE 'do not invest'
ORDER BY orig_play_rating DESC
LIMIT 10;

WITH ----- AS (
SELECT )



---Trying plan c with genres and content rating (Query of Fun)
SELECT DISTINCT a.primary_genre AS apple_genre, p.genres AS google_genre, p.content_rating, p.name,
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating,
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, ---NEED TO DETERMINE LONGEVITY (has to be to the nearest '0.5')
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating,
ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) AS play_longevity_years,
ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) AS app_longevity_years,
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS play_purchase_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS app_purchase_price,
CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END AS play_investment_analysis,
CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END AS app_investment_analysis
FROM play_store_apps AS p
JOIN app_store_apps AS a  ---DOING A JOIN BECAUSE THE APP NEEDS TO BE IN BOTH TABLES
USING(name)
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
AND (CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END) NOT LIKE 'do not invest'
AND (CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END) NOT LIKE 'do not invest'
ORDER BY orig_play_rating DESC
LIMIT 10;

---Query of Fun
WITH CTE_CASES AS(
SELECT a.name,
    CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS play_purchase_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS app_purchase_price,
CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 5000000 THEN 'okay'
      ELSE 'do not invest' END AS play_investment_analysis,
CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 200000 THEN 'okay'
      ELSE 'do not invest' END AS app_investment_analysis
 FROM play_store_apps AS p
 JOIN app_store_apps AS a
 USING (name)
)
SELECT DISTINCT a.primary_genre AS apple_genre, p.genres AS google_genre, p.content_rating, p.name,
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating,
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, ---NEED TO DETERMINE LONGEVITY (has to be to the nearest '0.5')
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating,
ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) AS play_longevity_years,
ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) AS app_longevity_years,
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
play_purchase_price, 
app_purchase_price,
play_investment_analysis,
app_investment_analysis
FROM play_store_apps AS p
JOIN app_store_apps AS a  
USING(name)
JOIN CTE_CASES
USING(name)
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
AND play_investment_analysis != 'do not invest' AND app_investment_analysis != 'do not invest'
ORDER BY orig_play_rating DESC
LIMIT 10;

---Query of Fun rd 2 - trying CTE with longevity, running into the issue that it's adding name, rating into the column with our aggregation 
WITH CTE_CASES AS(
SELECT a.name,
    CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS play_purchase_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS app_purchase_price,
CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 3000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 3000000 THEN 'okay'
      ELSE 'do not invest' END AS play_investment_analysis,
CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 150000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 150000 THEN 'okay'
      ELSE 'do not invest' END AS app_investment_analysis
 FROM play_store_apps AS p
 JOIN app_store_apps AS a
 USING (name)
),
Longevity_years AS (
SELECT 
    a.name, 
    ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) AS play_longevity_years,
    ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) AS app_longevity_years
FROM play_store_apps AS p
JOIN app_store_apps AS a
USING (rating)
)
SELECT DISTINCT a.primary_genre AS apple_genre, p.genres AS google_genre, p.content_rating, p.name,
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating,
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, 
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating,
play_longevity_years,
app_longevity_years,
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
play_purchase_price, 
app_purchase_price,
play_investment_analysis,
app_investment_analysis
FROM play_store_apps AS p
JOIN app_store_apps AS a  
USING(name)
JOIN CTE_CASES
USING(name)
JOIN Longevity_years
USING (name)
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
AND play_investment_analysis != 'do not invest' AND app_investment_analysis != 'do not invest'
ORDER BY orig_play_rating DESC
LIMIT 10;

---Query FUN
WITH CTE_CASES AS(
SELECT a.name,
    CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS play_purchase_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS app_purchase_price,
CASE WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 3000000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(p.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END) = 10000 AND p.review_count >= 3000000 THEN 'okay'
      ELSE 'do not invest' END AS play_investment_analysis,
CASE WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) >= 10 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 150000 THEN 'great'
    WHEN ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) = 9 AND (CASE WHEN CAST(MONEY(a.price) as NUMERIC) < 1.01 THEN 10000
    ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END) = 10000 AND CAST(a.review_count AS numeric) >= 150000 THEN 'okay'
      ELSE 'do not invest' END AS app_investment_analysis
 FROM play_store_apps AS p
 JOIN app_store_apps AS a
 USING (name)
)
SELECT DISTINCT a.primary_genre AS apple_genre, p.genres AS google_genre, p.content_rating, p.name,
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating,
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, 
ROUND(ROUND(a.rating/5,1)*5,1) AS app_rating,
ROUND(1+(ROUND(ROUND(p.rating/5,1)*5,1)/.5),0) AS play_longevity_years,
ROUND(1+(ROUND(ROUND(a.rating/5,1)*5,1)/.5),0) AS app_longevity_years,
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
play_purchase_price, 
app_purchase_price,
play_investment_analysis,
app_investment_analysis
FROM play_store_apps AS p
JOIN app_store_apps AS a  
USING(name)
JOIN CTE_CASES
USING(name)
WHERE A.RATING IS NOT NULL AND P.RATING IS NOT NULL
AND play_investment_analysis != 'do not invest' AND app_investment_analysis != 'do not invest'
ORDER BY orig_play_rating DESC
LIMIT 10;





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

