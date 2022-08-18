---I think this gives me the top 12 apps that appear in BOTH tables, have the longest longevity, lowest price buy out, 
---and has received a higher review count (so as to make the rating more reliable- at least that's what I thought)
SELECT DISTINCT p.name, 
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating, 
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, ---NEED TO DETERMINE LONGETIVITY (has to be to the nearest '0.5')
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
      ELSE 'do not invest' END AS app_investment_analysis,
(((50000*12)*10)-(10000+((1000*12)*10)) AS total_gains
FROM play_store_apps AS p
JOIN app_store_apps AS a  ---DOING A JOIN BECAUSE THE APP NEEDS TO BE IN BOTH TABLES 
ON P.NAME = A.NAME 
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
LIMIT 10; ---(5000*12*10 = 600,000 and 1000*12*10+10000 = 130,000 ... $470,000 (total retun off of investment)
-- ORDERED BY original play rating because there was twelve with the result, leaving two 4.3 ratings only in play_rating, 
-- so ordering by it and limiting to 10, I sorted out those lower ratings
--- ALSO - had to make a massive WHERE statement because where does not take an alias :( 

----ROUND MATH  4.4 / 5 = .88 = .9 THEN  .9 * 5 = 4.5  

---- WORKBOOK BELOW
SELECT * 
FROM app_store_apps

SELECT *
FROM play_store_apps
ORDER BY review_count DESC 
---can join on name, rating, price

SELECT * 
FROM app_store_apps
ORDER BY CAST(review_count AS numeric) DESC 

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


SELECT DISTINCT p.name, 
p.rating AS Orig_play_rating, a.rating AS Orig_app_rating, 
ROUND(ROUND(p.rating/5,1)*5,1) AS play_rating, ---NEED TO DETERMINING LONGETIVITY
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
ON P.NAME = A.NAME 
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
ORDER BY play_investment_analysis DESC;
---HIGHEST COMBINED APP RATINGS SORTED FIRST 
    
----ROUND MATH  4.4 / 5 = .88 = .9 THEN  .9 * 5 = 4.5                                 
                                     
--FIND HIGHEST RATED LEAST EXPENSIVE APPS ?????


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

