SELECT film_Title, length_in_min
	CASE WHEN length_in_min < (SELECT AVG(length_in_min) FROM specs) THEN 'shorter'
		 WHEN length_in_min > (SELECT AVG(length_in_min) FROM specs) THEN 'longer' END AS length_category
FROM specs;
	