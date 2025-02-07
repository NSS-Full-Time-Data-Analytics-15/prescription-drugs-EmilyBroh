----1a: Prescriber Bruce Pendley, NPI #1881634483, 99,707 claims
---Which prescriber had the highest total number of claims (totaled over all drugs)? 
 --Report the npi and the total number of claims.

SELECT DISTINCT( prescriber.nppes_provider_last_org_name, prescriber.nppes_provider_first_name), SUM(prescription.total_claim_count),
prescriber.npi
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NOT NULL
GROUP BY prescriber.nppes_provider_last_org_name, prescriber.nppes_provider_first_name, prescriber.npi
ORDER BY SUM(prescription.total_claim_count) DESC;

------- 1b: Syntax below 
-----Repeat the above, but this time report the nppes_provider_first_name, 
-----nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT prescriber.nppes_provider_last_org_name, prescriber.nppes_provider_first_name, 
				SUM(prescription.total_claim_count),
prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NOT NULL
GROUP BY prescriber.nppes_provider_last_org_name, 
		prescriber.nppes_provider_first_name, prescriber.specialty_description, prescriber.npi
ORDER BY SUM(prescription.total_claim_count) DESC;

-------2a: Family Practice
---Which specialty had the most total number of claims (totaled over all drugs)?

SELECT SUM(prescription.total_claim_count),
prescriber.specialty_description
FROM prescriber
INNER JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NOT NULL
GROUP BY prescriber.specialty_description
ORDER BY SUM(prescription.total_claim_count) DESC;

-------2b: Nurse Practitioner, however , that is a title, not a specialty, 
-----------so I'd say Family Practice is the true answer.

---Which specialty had the most total number of claims for opioids?

SELECT opioid_drug_flag 
FROM drug
--Opioids are flagged as 'N' or 'Y'

SELECT SUM(prescription.total_claim_count),
prescriber.specialty_description, drug.opioid_drug_flag
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
LEFT JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE prescription.total_claim_count IS NOT NULL
AND drug.opioid_drug_flag LIKE 'Y'
GROUP BY prescriber.specialty_description, drug.opioid_drug_flag
ORDER BY SUM(prescription.total_claim_count) DESC;

-------2c: Not sure here. I'll come back to this.
---Challenge Question: Are there any specialties that appear in the prescriber table that have no 
---associated prescriptions in the prescription table?



SELECT COUNT(prescription.total_claim_count), prescriber.npi,
 DISTINCT(prescriber.specialty_description)
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NULL
GROUP BY prescriber.specialty_description, prescriber.npi
ORDER BY prescriber.npi DESC;

---
SELECT SUM(prescription.total_claim_count), COUNT (DISTINCT prescriber.npi),
prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NULL
GROUP BY prescriber.specialty_description
ORDER BY COUNT (DISTINCT prescriber.npi) DESC;
---



-------2d:
---Difficult Bonus:** *Do not attempt until you have solved all other problems!
---For each specialty, report the percentage of total claims by that specialty which are for opioids. 
---Which specialties have a high percentage of opioids?









SELECT SUM(prescription.total_claim_count),
prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NOT NULL
GROUP BY prescriber.specialty_description
ORDER BY SUM(prescription.total_claim_count) DESC;

-------3a: In terms of drugs with a generic name, the answer is Bexarotene.  
--         When including nulls, (drugs without a listed generic name)
-------    Esbriet has the highest total drug cost. It does come in generic,

---Which drug (generic_name) had the highest total drug cost?

SELECT drug.generic_name, prescription.drug_name, prescription.total_drug_cost
FROM prescription
LEFT JOIN drug
ON drug.generic_name = prescription.drug_name
GROUP BY drug.generic_name, prescription.drug_name, prescription.total_drug_cost
ORDER BY prescription.total_drug_cost desc;

---
SELECT drug.generic_name, prescription.drug_name, prescription.total_drug_cost
FROM prescription
INNER JOIN drug
ON drug.generic_name = prescription.drug_name
WHERE drug.generic_name IS NOT NULL
GROUP BY drug.generic_name, prescription.drug_name, prescription.total_drug_cost
ORDER BY prescription.total_drug_cost desc;

---







-------3b: Immun Glob G(IGG)/GLY/IGA OV50 (Brand name: Gammagard Liquid).
				--**When I tried to select the drug name and generic name columns as distinct, 
					--I ran into a syntax processing error. That said, there are visibly duplicated medication
					--names on the list**
					
---Which drug (generic_name) has the hightest total cost per day? 
---**Bonus: Round your cost per day column to 2 decimal places. 


SELECT prescription.drug_name, drug.generic_name, 
		ROUND(prescription.total_drug_cost/prescription.total_day_supply,2) AS daily_cost
FROM prescription
LEFT JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE drug.generic_name IS NOT NULL
ORDER BY daily_cost desc;




SELECT prescription.drug_name, drug.generic_name, 
		ROUND(prescription.total_drug_cost/prescription.total_day_supply,2) AS daily_cost
FROM drug
LEFT JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE drug.generic_name IS NOT NULL
ORDER BY daily_cost desc;



-------4a: See syntax below
-----For each drug in the drug table, return the drug name and then a column named 'drug_type' which 
-----says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which 
-----have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** 
-----You may want to use a CASE expression for this. 

SELECT  drug.drug_name, drug.generic_name, 
	CASE 
		WHEN drug.opioid_drug_flag iLIKE 'Y' THEN 'Opioid' 
		ELSE 'neither'
		END as opioid,
	CASE
	WHEN drug.antibiotic_drug_flag iLIKE 'Y' THEN 'Antibiotic'
		ELSE 'neither'
		END as antibiotic
FROM drug

-- Originally I had this, but was getting too many columns. 
--I fixed it, but need to look into why SQL processed it like that.
SELECT  drug.drug_name, drug.generic_name, drug.opioid_drug_flag AS opioid, drug.antibiotic_drug_flag AS antibiotic,
	CASE 
		WHEN drug.opioid_drug_flag iLIKE 'Y' THEN 'Opioid' 
		ELSE 'N'
		END as opioid,
	CASE
	WHEN drug.antibiotic_drug_flag iLIKE 'Y' THEN 'Antibiotic'
		ELSE 'N'
		END as antibiotic
FROM drug
	
   
   
-------4b:
-----Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) 
-----on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.


SELECT SUM(prescription.total_drug_cost) AS total_cost,
	CASE 
		WHEN drug.opioid_drug_flag iLIKE 'Y' THEN 'Opioid' 
		ELSE 'neither'
		END as opioid,
	CASE
	WHEN drug.antibiotic_drug_flag iLIKE 'Y' THEN 'Antibiotic'
		ELSE 'neither'
		END as antibiotic
FROM prescription
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
GROUP BY drug.opioid_drug_flag, drug.antibiotic_drug_flag
ORDER BY total_cost desc

-------5a: 
-----Upon looking up the structure of an fips county code, I learned that the first 2 digits represent
-----the state. Tennessee is the 47th state alphabetically, which is why I filtered to include only rows
-----that contained '47' as the first two numbers.

-----How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, 
-----not just Tennessee.

SELECT *
FROM cbsa
WHERE fipscounty iLIKE '47%'
    
	
	
--look at this later-----5b: Largest combined population: Memphis, TN-MS-AR, 32820. Population 937,847
	   --Smallest combined population: Nashville-Davidson-Murfreesboro-Franklin, TN, 34980. Population 8,773

-----Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name 
-----and total population.	 

--   Note: **Population table ONLY contains TN values, therefore the question must be asking for the largest
--     and smallest combined population of TN CBSAs**


SELECT SUM(population.population), cbsa.cbsa, cbsa.cbsaname
FROM cbsa
INNER JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsa, population.population, cbsa.cbsaname
ORDER BY population.population DESC;




-------5c: Sevier County, population 95,523.
-----What is the largest (in terms of population) county which is not included in a CBSA? 
-----Report the county name and population.

SELECT population.fipscounty, cbsa.cbsa, fips_county.county, population.population
FROM fips_county
LEFT JOIN population
ON population.fipscounty = fips_county.fipscounty
LEFT JOIN cbsa
ON cbsa.fipscounty = population.fipscounty
WHERE population.population IS NOT NULL
AND cbsa.cbsa IS NULL
GROUP BY population.fipscounty, cbsa.cbsa, fips_county.county, population.population
ORDER BY population.population DESC;


-------6a: Syntax below. 
-------There are 9 drugs that match these parameters. They are as follows: Oxycodone Hcl, Lisinopril,
------- Gabapentin, Hydrocodone-APAP, Levothyroxine, Levothyroxine, Mirtazapine, Furosemide, Levothyroxine.

----------NOTE: Levothyroxine appears 3 times in this list, however I believe this to be due to
----------		 that medication coming in a handful of very common doses. Without more information,
----------		 however, this is just a guess. Also, I'm very surprised to see Mirtazapine on this list, 
----------       and I'd be curious to know in what context this is prescribed so frequently.


-----Find all rows in the prescription table where total_claims is at least 3000. 
-----Report the drug_name and the total_claim_count.



SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC

-----This next part is not part of the exercise- it's just something I looked at due to curiosity.

SELECT DISTINCT(prescriber.specialty_description), drug_name, total_claim_count
		--FROM prescription
		--LEFT JOIN prescriber
		--ON prescriber.npi = prescription.npi
		--WHERE drug_name iLIKE 'Mirtazapine'
		--GROUP BY prescriber.specialty_description, prescription.drug_name, prescription.total_claim_count
		--ORDER BY prescription.total_claim_count DESC;
		
-------6b: Syntax below.
-----For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

SELECT prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag
FROM prescription
LEFT JOIN drug
ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count >= 3000
GROUP BY prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag 
ORDER BY prescription.total_claim_count DESC;

		
-------6c: 
-----Add another column to your answer from the previous part which gives the prescriber first and 
-----last name associated with each row.

SELECT prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag,
		CONCAT(prescriber.nppes_provider_first_name, ' ', prescriber.nppes_provider_last_org_name) AS full_name
FROM prescription
LEFT JOIN drug
ON prescription.drug_name = drug.drug_name
LEFT JOIN prescriber
ON prescriber.npi = prescription.npi
WHERE prescription.total_claim_count >= 3000
GROUP BY prescription.drug_name, prescription.total_claim_count, drug.opioid_drug_flag, full_name 
ORDER BY prescription.total_claim_count DESC;



SELECT prescription.total_claim_count
FROM prescription
WHERE prescriber




---7.The goal of this exercise is to generate a full list of all pain management specialists in Nashville 
-----and the number of claims they had for each opioid. **Hint:** The results from all 3 
-----parts will have 637 rows.



-------7a:

-----------First, create a list of all npi/drug_name combinations for pain management specialists 
----------(specialty_description = 'Pain Management) in the city of Nashville 
----------(nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). 
---------**Warning:** Double-check your query before running it. You will only need to use the 
------------          0prescriber and drug tables since you don't need the claims numbers yet.


SELECT 
	prescriber.npi, 
	prescriber.specialty_description, 
	drug.drug_name, 
	drug.opioid_drug_flag,
	prescriber.nppes_provider_city
FROM prescriber
CROSS JOIN drug
WHERE prescriber.nppes_provider_city iLIKE 'Nashville'
AND prescriber.specialty_description iLIKE 'Pain Management'
AND drug.opioid_drug_flag iLIKE 'Y';







-------7b: Next, report the number of claims per drug per prescriber. Be sure to include all combinations, 
-----------whether or not the prescriber had any claims. 
-----------You should report the npi, the drug name, and the number of claims (total_claim_count).

--What I need: 

--prescription.total_claim_count
--new column to indicate claims Y or N?
--prescription.npi
--prescription.drug_name

WITH claim_count FROM prescription.total_claim_count

SELECT drug.drug_name,
	prescriber.npi, 
	prescriber.specialty_description,  
	SUM(prescription.total_claim_count) AS total_claim_count, 
	CONCAT(prescriber.nppes_provider_first_name, ' ', prescriber.nppes_provider_last_org_name) AS full_name
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE prescriber.nppes_provider_city iLIKE 'Nashville'
AND prescriber.specialty_description iLIKE 'Pain Management'
AND drug.opioid_drug_flag iLIKE 'Y'
GROUP BY drug.drug_name, prescriber.npi, prescriber.specialty_description, prescription.total_claim_count,
 full_name
ORDER BY drug.drug_name asc;

-------With more grouping options, in case that's what Chris wanted:

SELECT drug.drug_name,
	prescriber.npi, 
	prescriber.specialty_description,  
	drug.opioid_drug_flag,
	prescriber.nppes_provider_city, SUM(prescription.total_claim_count) AS total_claim_count, 
	CONCAT(prescriber.nppes_provider_first_name, ' ', prescriber.nppes_provider_last_org_name) AS full_name
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE prescriber.nppes_provider_city iLIKE 'Nashville'
AND prescriber.specialty_description iLIKE 'Pain Management'
AND drug.opioid_drug_flag iLIKE 'Y'
GROUP BY drug.drug_name, prescriber.npi, prescriber.specialty_description, prescription.total_claim_count,
drug.opioid_drug_flag, prescriber.nppes_provider_city, full_name
ORDER BY drug.drug_name asc;


-------7c: Ugh, need to fix COALESCE

-----------Finally, if you have not done so already, fill in any missing values for total_claim_count 
-----------with 0. Hint - Google the COALESCE function.

SELECT drug.drug_name,
	prescriber.npi, 
	prescriber.specialty_description,  
	drug.opioid_drug_flag,
	prescriber.nppes_provider_city, COALESCE((prescription.total_claim_count) 0), AS total_claim_count, 
	CONCAT(prescriber.nppes_provider_first_name, ' ', prescriber.nppes_provider_last_org_name) AS full_name
FROM prescriber
INNER JOIN prescription
ON prescriber.npi = prescription.npi
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE prescriber.nppes_provider_city iLIKE 'Nashville'
AND prescriber.specialty_description iLIKE 'Pain Management'
AND drug.opioid_drug_flag iLIKE 'Y'
GROUP BY drug.drug_name, prescriber.npi, prescriber.specialty_description, prescription.total_claim_count,
drug.opioid_drug_flag, prescriber.nppes_provider_city, full_name
ORDER BY drug.drug_name asc;
