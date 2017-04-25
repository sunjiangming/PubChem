#!/bin/bash
## clean PubChem data (confirmatory assays)
# $2 output dir same as in step1.sh
# $1 ID list, same as in step1, e.g. confirmatory_single_target_assay_ID_list.txt
# e.g. sh step2.sh confirmatory_single_target_assay_ID_list.txt outdir

echo -e "Assembly Assays into single text file\n"
if [ -e $1.dumped_assays.tsv ]
then
	rm $1.dumped_assays.tsv
fi

while read -r aid others
do
	if [ -s "$2"/"$aid".txt ]; then
	lines=$(wc -l < "$2"/"$aid".txt)
		if [ "$lines" -ge 2 ]; then
			#1. remove unwanted AC names and only active and inactive output are left
			#2. remove Entrez_ID-missing data point, $6
			#3. reomve substances if CID is blank, $2
			# header of output: AID, CID, Activity, AC Value (micromolar), AC Name and GeneID
			cut -f 1,4-7,13 $2/$aid.txt | awk -F"\t" '{ if(($3=="Active" || $3=="Inactive" ) && ($2!="" && $6!="" && substr($5,length($5)-2,3)=="C50" || substr($5,length($5)-3,4)=="GI50" || $5=="Potency" || $5=="TGI" || $5=="MIC" || $5=="MEC" || $5=="KI" || $5=="KD" || $5=="A2")) print $0;}'  > $1.dumped_t1.tsv
			if [ -s $1.dumped_t1.tsv ]; then
				#4 convert AC Value (micromolar) to XC50, set missng pXC value as blank
				# header: AID, CID, Activity, pXC50 and GeneID
				awk 'BEGIN{FS="\t";OFS="\t"} { if($4+0 > 0) print $1,$2,$3,6-log($4)/log(10),$6; else print $1,$2,$3,"",$6; }' $1.dumped_t1.tsv >> $1.dumped_assays.tsv
				rm $1.dumped_t1.tsv
			else
				echo -e "Assay $aid is filtered out...\n"
				rm $1.dumped_t1.tsv
			fi
		else
			echo -e "Assay $aid have single line...\n"
		fi
	fi
done < $1


if [ -e $1.dumped_assays.tsv ]; then
	#5 active: A; inactive: N
	sed -e 's|\tInactive\t|\tN\t|' $1.dumped_assays.tsv | sed -e 's|\tActive\t|\tA\t|' > $1.dumped_assays.cleaned.tsv
	rm $1.dumped_assays.tsv
fi
