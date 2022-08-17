-- Difference of 1,511 apps
-- Both App Store and Play Store:   328 with DISTINCT /    553 without DISTINCT
-- Only in App Store:             6,867 with DISTINCT /  6,869 without DISTINCT
-- Only in Play Store:            9,331 with DISTINCT / 10,287 without DISTINCT
-- UNION ALL method:             16,526 with DISTINCT / 18,037 without DISTINCT
-- UNION method:                 16,526 with DISTINCT / 16,526 without DISTINCT
SELECT name
FROM app_store_apps
INNER JOIN play_store_apps
USING(name);
--
SELECT name
FROM app_store_apps
WHERE name NOT IN (
  SELECT name
  FROM play_store_apps);
-- 
SELECT name
FROM play_store_apps
WHERE name NOT IN (
  SELECT name
  FROM app_store_apps);
-- 
SELECT name
FROM app_store_apps
UNION ALL
SELECT name
FROM play_store_apps;
-- 
SELECT name
FROM app_store_apps
UNION
SELECT name
FROM play_store_apps;


/*
ONE : App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.
*/

/*
TWO : Apps earn $5000 per month on average from in-app advertising and in-app purchases _regardless_ of the price of the app.
*/

/*
THREE : App Trader will spend an average of $1000 per month to market an app _regardless_ of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.
*/

/*
FOUR : For every half point that an app gains in rating, its projected lifespan increases by one year, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.5 to evaluate an app's likely longevity.
*/
-- Write a query to find longevity according to genre
-- App Store:
SELECT
  name,
  CASE WHEN CAST(rating AS int) BETWEEN 0 and 0.5 THEN '1'
       WHEN CAST(rating AS int) BETWEEN 0.6 AND 1 THEN '2'
       WHEN CAST(rating AS int) BETWEEN 1.1 AND 1.5 THEN '3'
       WHEN CAST(rating AS int) BETWEEN 1.6 AND 2 THEN '4'
       WHEN CAST(rating AS int) BETWEEN 2.6 AND 3 THEN '5'
       WHEN CAST(rating AS int) BETWEEN 3.6 AND 4 THEN '6'
       ELSE '7' END AS longevity
FROM app_store_apps --consider using a UNION for name, ratings then use the CASE WHEN...THEN...
-- Play Store:

/*
FIVE : App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.
*/