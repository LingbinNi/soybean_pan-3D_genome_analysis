#!/bin/bash

for dir in $(ls -d /TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample
for file in $(ls $dir/$sample\_SelfMapping_Merge_25000_KR_Chr*_dense.matrix)
do
filename=$(basename $file .matrix)
/software/domaincall_software/perl_scripts/DI_from_matrix.pl \
$file \
25000 \
2000000 \
/DataBase/04.genome/$sample.v1.fasta.fai \
> $filename.di
done
cd ..
done
