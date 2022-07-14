#!/bin/bash

for file in $(ls ./01.CoordinatesConversion/00.ChainFiles/TZX*ToTZX544.over.chain.gz)
do
sample=$(basename $file ToTZX544.over.chain.gz)
mkdir $sample
cd $sample
CrossMap.py region \
$file \
/01.InsulationBoundaryList/01.InsulationBoundary/$sample-InsulationBoundary \
$sample-TZX544-InsulationBoundary
cd ..
done
