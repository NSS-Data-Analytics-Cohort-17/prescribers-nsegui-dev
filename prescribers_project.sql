--Q1a

SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC
LIMIT 1;

--Q1b

SELECT nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber USING (npi)
WHERE total_claim_count IS NOT NULL
GROUP BY npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
ORDER BY total_claims DESC
LIMIT 1;

--Q2a

SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber 
INNER JOIN prescription USING (npi)
GROUP BY specialty_description
ORDER BY total_claims DESC
LIMIT 1;

--Q2b

SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber 
INNER JOIN prescription USING (npi)
INNER JOIN drug USING (drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_claims DESC
LIMIT 1;

--Q2c

SELECT DISTINCT specialty_description
FROM prescriber
EXCEPT
SELECT DISTINCT specialty_description
FROM prescription
INNER JOIN prescriber USING (npi);

--Q2d

SELECT specialty_description, 
SUM(CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count ELSE 0 END) AS opioid_claims,
SUM(total_claim_count) AS total_claims,
ROUND(SUM(CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count ELSE 0 END)/ SUM(total_claim_count) * 100, 2) AS opioid_percentage
FROM prescriber
INNER JOIN prescription USING (npi)
INNER JOIN drug USING (drug_name)
GROUP BY specialty_description;

--Q3a

SELECT generic_name, SUM(total_drug_cost) AS total_cost
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY generic_name
ORDER BY total_cost DESC
LIMIT 1;

--Q3b

SELECT generic_name, ROUND(SUM(total_drug_cost)/ SUM(total_day_supply), 2) AS total_cost_per_day
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY generic_name
ORDER BY total_cost_per_day DESC
LIMIT 1;

--Q4a

SELECT drug_name,
CASE
WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug;

--Q4b

SELECT SUM(total_drug_cost::money) AS sum_cost,
CASE
WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY drug_type
ORDER BY sum_cost DESC;

--Q5a

SELECT COUNT (DISTINCT cbsa)
FROM cbsa
INNER JOIN fips_county USING (fipscounty)
WHERE state = 'TN';

--Q5b

SELECT cbsaname, SUM(population) AS total_pop
FROM cbsa
INNER JOIN population USING (fipscounty)
GROUP BY cbsaname
ORDER BY total_pop DESC;

--Q5c

SELECT county, population
FROM fips_county
FULL JOIN cbsa USING (fipscounty)
LEFT JOIN population  USING (fipscounty)
WHERE cbsa IS NULL
ORDER BY population DESC NULLS LAST;

--Q6a

SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;

--Q6b

SELECT drug.drug_name, total_claim_count, opioid_drug_flag
FROM prescription
INNER JOIN drug ON drug.drug_name = prescription.drug_name
WHERE total_claim_count >= 3000;

--Q6c

SELECT drug.drug_name, total_claim_count, opioid_drug_flag, nppes_provider_first_name, nppes_provider_last_org_name
FROM prescription
INNER JOIN drug ON drug.drug_name = prescription.drug_name
INNER JOIN prescriber ON prescriber.npi = prescription.npi
WHERE total_claim_count >= 3000;

--Q7a

SELECT npi, drug_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'NASHVILLE'
AND opioid_drug_flag = 'Y';

--Q7b

SELECT npi, drug_name, total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription USING (npi, drug_name)
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'NASHVILLE'
AND opioid_drug_flag = 'Y';

--Q7c

SELECT npi, drug_name, COALESCE(total_claim_count, 0)
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription USING (npi, drug_name)
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'NASHVILLE'
AND opioid_drug_flag = 'Y'