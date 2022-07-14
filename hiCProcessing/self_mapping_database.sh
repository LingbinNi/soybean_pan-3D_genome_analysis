#!/bin/bash

for file in $(ls /genomes)
do

filename=$(basename $file .v1.fasta)
samplename=${filename/TZX-/TZX}
echo $samplename...

#database
##mkdir
mkdir -p $samplename/database/reference
mkdir -p $samplename/database/index
mkdir -p $samplename/database/annotation
##reference
cp /genomes/$filename.v1.fasta ./$samplename/database/reference
##index
bowtie2-build ./$samplename/database/reference/$filename.v1.fasta ./$samplename/database/index/$samplename
##annotation
###GmaxZH13_v2_mboi_dpnii.bed
/software/HiC-Pro/HiC-Pro_2.9.0/bin/utils/digest_genome.py -r mboi -o $samplename/database/annotation/$samplename'_mboi_dpnii.bed' ./$samplename/database/reference/$filename.v1.fasta
###chrom_gmZH13.sizes
samtools faidx ./$samplename/database/reference/$filename.v1.fasta
cut -f1,2 ./$samplename/database/reference/$filename.v1.fasta.fai > $samplename/database/annotation/chrom_$samplename.sizes

#reads
##mv
mv /reads/$samplename'A' ./$samplename/reads/
mv /reads/$samplename'B' ./$samplename/reads/

#config
##cp
cp config_base.txt ./$samplename/config-$samplename.txt
##sed
sed -i "39 s/<samplename>/$samplename/g" ./$samplename/config-$samplename.txt
sed -i "47 s/<samplename>/$samplename/g" ./$samplename/config-$samplename.txt
sed -i "48 s/<samplename>/$samplename/g" ./$samplename/config-$samplename.txt
sed -i "61 s/<samplename>/$samplename/g" ./$samplename/config-$samplename.txt

done
