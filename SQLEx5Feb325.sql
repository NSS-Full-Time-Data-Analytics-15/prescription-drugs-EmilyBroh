-------1a: 7.1%
----For this question, you will be looking for which county (or counties) had the most months with an unemployment 
---rate above the state average. First, create a query that returns the the overall average unemployment rate 
--across all counties. We will treat each county equally, so don’t worry about weighting by population or anything.

SELECT AVG(value)
FROM unemployment;
---1b: Top 4(tie): Giles, Sevier, Benton, Loudon

SELECT COUNT(period) AS months, county
FROM unemployment
		WHERE value > (SELECT AVG(value) FROM unemployment)
GROUP BY county
ORDER BY COUNT(period) desc




--
SELECT DISTINCT(period_name), county,COUNT (period), value
FROM unemployment
		WHERE value > (SELECT AVG(value) FROM unemployment);

----
-----2a: See syntax below. Eastman Chemical Company had largest capital investment.
---First write a query to find each company’s largest capital investment, returning the company name along 
---with the relevant capital investment amount for each.

SELECT company, MAX(capital_investment)
FROM ecd
WHERE capital_investment IS NOT NULL
ORDER BY capital_investment DESC;






---2b: Syntax below, although I need to go back and double check that.  Noah and Jake say to use MAX on capital investment
	-- due to company name duplicates.
	
---Use this query in the FROM statement of an outer query (remember you must alias!) and join it 
---to the unaltered ecd table (you’ll need to join on TWO column names).  
---For now just do SELECT * in the outer query to make sure your join worked properly. 
---You should have the same number of rows as the output from part a, but you should have all 
---the columns available in the ecd table.


SELECT *
	FROM(SELECT company, capital_investment
		 FROM ecd
	WHERE capital_investment IS NOT NULL
	ORDER BY capital_investment DESC) AS wtf
INNER JOIN ecd
	ON wtf.company = ecd.company
	AND wtf.capital_investment = ecd.capital_investment;

-----2c: Top 3: Maury, Hamilton, Montgomery
--Once your join is working, adjust your outer query SELECT statement to get the 
--average number of jobs by county.

SELECT AVG(new_jobs), county
	FROM(SELECT company, MAX(capital_investment)
		 FROM ecd
	WHERE capital_investment IS NOT NULL
	ORDER BY capital_investment DESC) AS wtf
INNER JOIN ecd
	ON wtf.company = ecd.company
	AND wtf.capital_investment = ecd.capital_investment
GROUP BY county, new_jobs
ORDER BY new_jobs DESC;

