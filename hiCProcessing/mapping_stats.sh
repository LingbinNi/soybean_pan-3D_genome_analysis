#!/bin/bash

for file in $(ls -d /TZX*)
do
sample=$(basename $file)
echo $sample
#A
echo $sample'A' >> $sample'A'.temp
awk 'NR==11{print $2}' $file/output/hic_results/data/$sample'A'/$sample'A'.mRSstat >> $sample'A'.temp
echo " " >> $sample'A'.temp
awk 'NR==13{print $2}' $file/output/hic_results/data/$sample'A'/$sample'A'.mRSstat >> $sample'A'.temp
echo " " >> $sample'A'.temp
awk 'NR==15{print $2}' $file/output/hic_results/data/$sample'A'/$sample'A'.mRSstat >> $sample'A'.temp
echo " " >> $sample'A'.temp
awk 'NR==12{print $2}' $file/output/hic_results/data/$sample'A'/$sample'A'.mRSstat >> $sample'A'.temp
echo " " >> $sample'A'.temp
awk 'NR==1{print $2}' $file/output/hic_results/data/$sample'A'/$sample'A'_allValidPairs.mergestat >> $sample'A'.temp
echo " " >> $sample'A'.temp
awk 'NR==2{print $2}' $file/output/hic_results/data/$sample'A'/$sample'A'_allValidPairs.mergestat >> $sample'A'.temp
echo " " >> $sample'A'.temp
echo " " >> $sample'A'.temp
#B
echo $sample'B' >> $sample'B'.temp
awk 'NR==11{print $2}' $file/output/hic_results/data/$sample'B'/$sample'B'.mRSstat >> $sample'B'.temp
echo " " >> $sample'B'.temp
awk 'NR==13{print $2}' $file/output/hic_results/data/$sample'B'/$sample'B'.mRSstat >> $sample'B'.temp
echo " " >> $sample'B'.temp
awk 'NR==15{print $2}' $file/output/hic_results/data/$sample'B'/$sample'B'.mRSstat >> $sample'B'.temp
echo " " >> $sample'B'.temp
awk 'NR==12{print $2}' $file/output/hic_results/data/$sample'B'/$sample'B'.mRSstat >> $sample'B'.temp
echo " " >> $sample'B'.temp
awk 'NR==1{print $2}' $file/output/hic_results/data/$sample'B'/$sample'B'_allValidPairs.mergestat >> $sample'B'.temp
echo " " >> $sample'B'.temp
awk 'NR==2{print $2}' $file/output/hic_results/data/$sample'B'/$sample'B'_allValidPairs.mergestat >> $sample'B'.temp
echo " " >> $sample'B'.temp
echo " " >> $sample'B'.temp
done
#rownames
echo ',
,Dangling End Paired-end Reads
,Dangling End Rate (%)
,Self Circle Paired-end Reads
,Self Circle Rate (%)
,Dumped Paired-end Reads
,Dumped Rate (%)
,Religation Paired-end Reads
,Religation Rate (%)
,Interaction Paired-end Reads
,Interaction Rate (%)
,Valid Paired-end Reads
,Valid Rate (%)
,Dup (%)' > rownames.temp

paste -d"," rownames.temp TZX*.temp > mapping_stat.csv

rm *.temp
