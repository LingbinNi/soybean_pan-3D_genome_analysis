#!/bin/bash

for file in $(ls /01.InsulationBoundary/TZX*-InsulationBoundary)
do
sample=$(basename $file -InsulationBoundary)
filename=$(basename $file)
echo $sample
awk -v name="$sample" '{print $1"\t"$2-25000"\t"$3+25000"\t"name"-"$1"-"$2"-"$3}' $file > $filename.bed
bedtools getfasta -fi /DataBase/04.genome/$sample.*.fasta -bed $filename.bed -fo $filename.fasta -name
done
