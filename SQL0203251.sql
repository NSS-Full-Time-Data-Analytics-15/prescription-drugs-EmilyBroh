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

SELECT DISTINCT( prescriber.nppes_provider_last_org_name, prescriber.nppes_provider_first_name), SUM(prescription.total_claim_count),
prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NOT NULL
GROUP BY prescriber.nppes_provider_last_org_name, prescriber.nppes_provider_first_name, prescriber.specialty_description
ORDER BY SUM(prescription.total_claim_count) DESC;

-------2a: Family Practice
---Which specialty had the most total number of claims (totaled over all drugs)?

SELECT SUM(prescription.total_claim_count),
prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription
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




SELECT SUM(prescription.total_claim_count), COUNT (DISTINCT prescriber.npi),
prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription
ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count IS NULL
GROUP BY prescriber.specialty_description
ORDER BY COUNT (DISTINCT prescriber.npi) DESC;

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

-------3a: In terms of drugs with a generic name, the answer is Bexarotene.  When including nulls, (drugs without a listed generic name)
-------    Esbriet has the highest total drug cost
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
LEFT JOIN drug
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


SELECT prescription.drug_name, drug.generic_name, ROUND(prescription.total_drug_cost/prescription.total_day_supply,2) AS daily_cost
FROM prescription
LEFT JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE drug.generic_name IS NOT NULL
ORDER BY daily_cost desc;


-------4a: See syntax below
-----For each drug in the drug table, return the drug name and then a column named 'drug_type' which 
-----says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which 
-----have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** 
-----You may want to use a CASE expression for this. 

SELECT  drug.drug_name, drug.generic_name, drug.opioid_drug_flag AS opioid, drug.antibiotic_drug_flag AS antibiotic,
	CASE 
		WHEN drug.opioid_drug_flag iLIKE 'Y' THEN 'Opioid' 
		ELSE 'Neither'
		END as opioid,
	CASE
	WHEN drug.antibiotic_drug_flag iLIKE 'Y' THEN 'Antibiotic'
		ELSE 'Neither'
		END as antibiotic
FROM drug
	
   
   
-------4b:
-----Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) 
-----on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.



