#!/bin/bash
# $1 ID list, e.g. primary-screening.single_target_assay_ID_list.txt
# $2 output dir
##A. Downlaod PubChem data by given assay IDs, one ID per line
sh step1.sh $1 $2
##B. clean PubChem primary screening data and keep only inactive data points

#e.g. sh step3.sh primary-screening.single_target_assay_ID_list.txt outdir2

echo -e "Assembly Screening Assays into single text file\n"
if [ -e $1.dumped_screening_assays.cleaned.tsv ]
then
	rm $1.dumped_screening_assays.cleaned.tsv
fi

while read -r aid others
do
	if [ -s "$2"/"$aid".txt ]; then
	lines=$(wc -l < "$2"/"$aid".txt)
		if [ "$lines" -ge 2 ]; then
			#1 Keep Inactives
			#2 remove EntrezID-missing data point
			#3 reomve substances if CID is blank
			# header: AID, CID, Activity, pXC50 and GeneID
			cut -f 1,4-6,13 $2/$aid.txt | awk -F"\t" '$3=="Inactive" && $2!="" && $5!="" '  >> $1.dumped_screening_assays.cleaned.tsv
		fi
	fi
done < $1

if [ -e $1.dumped_screening_assays.cleaned.tsv ]; then
	#4 inactive: N
	sed -i -e 's|\tInactive\t|\tN\t|' $1.dumped_screening_assays.cleaned.tsv
fi
