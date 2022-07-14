#!/bin/bash

for dir in $(ls -d ./01.SplitSparse/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample

for file in $(ls $dir/TZX*_Chr*.matrix)
do
filename=$(basename $file .matrix)
#Load
cooler load --one-based -f coo $dir/$filename\_abs.bed $file $filename.cool
#Balance
cooler balance $filename.cool
#Call compartments
cooltools call-compartments -o $filename\_Compartment $filename.cool
done

cd ..
done
