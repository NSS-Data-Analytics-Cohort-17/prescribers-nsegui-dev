--Q1a

SELECT prescriber.npi, total_claim_count
FROM prescriber 
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC
LIMIT 1;

--Q1b

SELECT nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, total_claim_count
FROM prescriber 
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC
LIMIT 1;

--Q2a

SELECT specialty_description, total_claim_count
FROM prescriber 
INNER JOIN prescription ON prescriber.npi = prescription.npi
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC
LIMIT 1;

--Q2b

SELECT specialty_description, total_claim_count
FROM prescriber 
INNER JOIN prescription ON prescriber.npi = prescription.npi
INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE total_claim_count IS NOT NULL
AND opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC
LIMIT 1;

--Q2c

--Q2d

--Q3a

SELECT generic_name, total_drug_cost
FROM drug
INNER JOIN prescription ON prescription.drug_name = drug.drug_name
ORDER BY total_drug_cost DESC
LIMIT 1;

--Q3b

SELECT generic_name, ROUND(total_drug_cost/total_day_supply, 2) AS cost_per_day
FROM drug
INNER JOIN prescription ON prescription.drug_name = drug.drug_name
ORDER BY cost_per_day DESC
LIMIT 1;

--Q4a

