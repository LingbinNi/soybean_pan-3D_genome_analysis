#!/bin/bash

#mapping
for dir in $(ls -d /6.RNA-Accession-Reads/Cleandata/TZX*)
do
dirname=$(basename $dir)
samplename=${dirname%-*}
sample=${samplename/-/}
echo $samplename
/software/hisat2-2.1.0/hisat2 -q -p 11 -x ../00.reference/$sample/$sample -1 $dir/$dirname"_R1.fq.gz" -2 $dir/$dirname"_R2.fq.gz" -S ./$dirname.sam
done
#bam
for file in `ls /RNAseq/01.mapping/*.sam`
do
name=$(basename $file .sam)
samtools view -Su $file | samtools sort -o ./$name.sorted.bam
done
#stringtie
for file in $(ls /RNAseq/02.bam/*.sorted.bam)
do
filename=$(basename $file .sorted.bam)
samplename=${filename%-*}
stringtie -p 12 $file -G /RNAseq/00.gff/$samplename.gene.gff -o $filename.gtf -A $filename.gene_abund.tab -e
done
