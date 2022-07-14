#!/bin/bash

for dir in $(ls -d /TZX*)
do
sample=$(basename $dir)
echo $sample
mkdir $sample'_SelfMapping_Merge_25KB_TAD'
cd $sample'_SelfMapping_Merge_25KB_TAD'
java -jar /software/Juicer/juicer_tools.1.9.8_jcuda.0.8.jar arrowhead -r 25000 /$sample/$sample'_SelfMapping_Merge_allValidPairs.hic' ./ 1>$sample.o 2>$sample.e
cd ..
done
