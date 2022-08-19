--ANDREW"S WORK ON ASSUMPTION 1
Select (name), p.genres, 
MONEY(p.price) AS play_price,
MONEY(a.price) AS app_price,
CASE WHEN CAST(MONEY(p.price) as NUMERIC) <= 1.00 THEN 10000
  ELSE CAST(MONEY(p.price) AS NUMERIC) * 10000 END AS total_play_price,
CASE WHEN CAST(MONEY(a.price) as NUMERIC) <= 1.00 THEN 10000
  ELSE CAST(MONEY(a.price) AS NUMERIC) * 10000 END AS total_app_price
From play_store_apps AS p
Join app_store_apps AS a
USING (name)
Group By p.name, a.name, MONEY(a.price), MONEY(p.price), p.genres
Order by total_app_price, total_play_price


Select *
From app_store_apps
Order By content_rating

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

--HANNAH'S WORK
---I think this gives me the top 12 apps that appear in BOTH tables, have the longest longevity, lowest price buy out,
---and has received a higher review count (so as to make the rating more reliable- at least that's what I thought)
SELECT DISTINCT p.name, p.genres,
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
LIMIT 12; ---(5000*12*10 = 600,000 and 1000*12*10+10000 = 130,000 ... $470,000 (total retun off of investment)
-- ORDERED BY original play rating because there was twelve with the result, leaving two 4.3 ratings only in play_rating,
-- so ordering by it and limiting to 10, I sorted out those lower ratings
--- ALSO - had to make a massive WHERE statement because where does not take an alias :(

----ROUND MATH  4.4 / 5 = .88 = .9 THEN  .9 * 5 = 4.5  


