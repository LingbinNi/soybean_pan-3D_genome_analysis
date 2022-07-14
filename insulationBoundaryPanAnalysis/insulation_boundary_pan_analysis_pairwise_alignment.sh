#!/bin/bash

#nucmer [options] ref:path qry:path+

###alignment
for file1 in $(ls /01.Fasta/TZX*-InsulationBoundary.fasta)
do
sample1=$(basename $file1 -InsulationBoundary.fasta)
#each sample
for file2 in $(ls /01.Fasta/TZX*-InsulationBoundary.fasta)
do
sample2=$(basename $file2 -InsulationBoundary.fasta)
echo $sample1-$sample2
bsub -n 1 -q lowl -J $sample1-$sample2 -o $sample1-$sample2.o -e $sample1-$sample2.e \
/software/mummer-4.0.0beta2/bin/nucmer -c 5000 -b 1000 $file1 $file2 -p $sample1-$sample2
done
done

###filter
for file in $(ls TZX*-TZX*.delta)
do
filename=$(basename $file .delta)
/software/mummer-4.0.0beta2/bin/delta-filter -m $filename.delta > $filename.flt.delta
/software/mummer-4.0.0beta2/bin/show-coords -bcHlorT $filename.flt.delta > $filename.flt.coords
done
