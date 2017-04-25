# PubChem
Bash script for retrieving bioactivity data from PubChem by given assay IDs

## Prepare assay ID list
ID can be retrieved via https://www.ncbi.nlm.nih.gov/pcassay/limits

## Step 1 Obtain data from PubChem
sh step1.sh confirmatory_single_target_assay_ID_list.txt outdir

## Step 2 Clean data from confirmatory assays
sh step2.sh confirmatory_single_target_assay_ID_list.txt outdir
1. Remove unwanted AC names and only active and inactive output are left
2. Remove Entrez_ID-missing data point
3. Reomve substance if CID is blank
4. Convert AC Value (micromolar) to pXC50, set missng pXC value as blank
5. Active: A; inactive: N

## Step 3 Obtain inactive data points from primary screening assays
sh step3.sh primary-screening.single_target_assay_ID_list.txt outdir2
1. Keep Inactives
2. Remove EntrezID-missing data point
3. Reomve substances if CID is blank
4. Inactive: N
