# PubChem
Bash script for retrieving bioactivity data from PubChem by given assay IDs

## Prepare assay ID list
ID can be retrieved via https://www.ncbi.nlm.nih.gov/pcassay/limits

## Step 1 Obtain data from PubChem
sh step1.sh confirmatory_single_target_assay_ID_list.txt outdir

## Step 2 Clean data
sh step2.sh confirmatory_single_target_assay_ID_list.txt outdir
