1. Write a CTE called top_gold_winter to find the top 5 gold-medal-winning countries for 
winter games in the database. Then write query to select the countries 
and the number of medals from the CTE where the total gold medals won is greater than or equal to 5.

WITH gold_medals
	SELECT gold, country_id
	FROM winter_games
	LEFT JOIN countries
	ON countries.id = winter_games.country_id



--2a: This was not my fave.
---Write a CTE called tall_athletes to find the athletes in the database who are taller than the average height 
---for all athletes in the database. 





------Including all athletes

WITH tall_athletes AS (
	SELECT AVG(height) AS average_height
	FROM athletes)
SELECT athletes.name,
				CASE 
					WHEN height > (SELECT average_height 
									FROM tall_athletes) THEN 'above_average'
									ELSE 'average_or_below'
									END AS tall
FROM athletes
ORDER BY height desc;

---Including only athletes above average height

WITH tall_athletes AS (
	SELECT AVG(height) AS average_height
	FROM athletes)
SELECT athletes.name,
				CASE 
					WHEN height > (SELECT average_height 
									FROM tall_athletes) THEN 'above_average'
									ELSE 'average_or_below'
									END AS tall
FROM athletes
WHERE height > (SELECT AVG(height) FROM athletes)
ORDER BY height desc;

---2b: Coming back to this later. I need to figure out how to exclude the male data.

---Next query that data to get just the female athletes who are taller than the 
---average height for all athletes and are over the age of 30.

WITH tall_athletes AS (
	SELECT AVG(height) AS average_height
	FROM athletes)
SELECT athletes.name, athletes.gender, athletes.age, athletes.height,
				CASE 
					WHEN height > (SELECT average_height 
									FROM tall_athletes) THEN 'above_average'
									ELSE 'average_or_below'
									END as tall
				
FROM athletes
WHERE gender iLIKE 'F'
AND age > 30
GROUP BY athletes.name, athletes.gender, athletes.age, athletes.height
ORDER BY height desc;

---Test syntax for above question is seen below

SELECT gender, age
FROM athletes
WHERE gender iLIKE 'F'
AND age > 30
----


			--WITH tall_over30_female_athletes AS (
				--SELECT AVG(height) AS average_height
				--FROM athletes
				--WHERE gender iLIKE 'F'
				--AND age > 30
				--AND height IS NOT NULL
				)
			--SELECT ROUND(average_height,2)
			--FROM tall_over30_female_athletes



--3.Write a CTE called tall_over30_female_athletes that returns the final results of exercise 2 above. 
--
---Next query the CTE to find the average weight for the over 30 female athletes.




WITH tall_over30_female_athletes AS (
	SELECT AVG(weight) AS average_weight
	FROM athletes
	WHERE gender iLIKE 'F'
	AND age > 30
	AND weight IS NOT NULL
	)
SELECT ROUND(average_weight,2)
FROM tall_over30_female_athletes

-----


WITH tall_over30_female_athletes AS (
	SELECT AVG(weight) AS average_weight
	FROM athletes
	WHERE gender iLIKE 'F'
	AND age > 30
	AND weight IS NOT NULL
	)
SELECT athletes.name, athletes.gender, athletes.age, athletes.weight
FROM athletes
WHERE athletes.weight IS NOT NULL
AND gender iLIKE 'F'
AND age > 30
GROUP BY athletes.name, athletes.gender, athletes.age, athletes.weight, 
ORDER BY weight asc




--Aggregate = Aggravate. Haha






--
WHERE gender iLIKE 'F'
	AND age > 30
	AND weight IS NOT NULL
--



LEFT JOIN summer_games
ON athletes.name





