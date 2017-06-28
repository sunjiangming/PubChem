#$1, input csv
#$2, output tsv
sed -r ':a;s/(("[^"]*",)*"[^",]+),/\1\n/;ta;s/"//g;y/,\n/\t,/' $1 > $2
