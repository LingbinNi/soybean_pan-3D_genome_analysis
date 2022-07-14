#!/bin/bash

for dir in $(ls -d /03.StructuralVariationFormat/0*)
do
dirname=$(basename $dir)
mkdir $dirname
cd $dirname

for file in $(ls $dir/TZX*.*.format.txt)
do
filename=$(basename $file .format.txt)
samplename=${filename%.*}
svname=${filename#*.}

echo '#!/usr/bin/env Rscript

sv=read.table("/01.StructuralVariationFormat/'$dirname'/'$samplename'.'$svname'.format.txt",header=F)
colnames(sv)=c("refchr","type","refstart","refend","qrychr","qrystart","qryend")
compartment=read.csv("/SelfMapping_AB_correction/'$samplename'_AB_correction.csv",header=T)

for (i in 1:nrow(compartment)){
number=nrow(sv[which( (as.character(sv[,5])==as.character(compartment[i,1]) & as.numeric(sv[,6])>=as.numeric(compartment[i,2]) & as.numeric(sv[,6])<=as.numeric(compartment[i,3])) | (as.character(sv[,5])==as.character(compartment[i,1]) & as.numeric(sv[,7])>=as.numeric(compartment[i,2]) & as.numeric(sv[,7])<=as.numeric(compartment[i,3])) | (as.character(sv[,5])==as.character(compartment[i,1]) & as.numeric(sv[,6])<=as.numeric(compartment[i,2]) & as.numeric(sv[,7])>=as.numeric(compartment[i,3])) ),])
compartment[i,5]=number
}
colnames(compartment)[5]="number"

write.csv(compartment,"StructuralVariationNumber.'$samplename'.'$svname'.csv",row.names=F,quote=F)' > StructuralVariationNumber.$samplename.$svname.R
###run###
chmod 755 StructuralVariationNumber.$samplename.$svname.R
echo StructuralVariationNumber.$samplename.$svname
bsub -n 1 -q lowl -J StructuralVariationNumber.$samplename.$svname -o StructuralVariationNumber.$samplename.$svname.o -e StructuralVariationNumber.$samplename.$svname.e \
Rscript StructuralVariationNumber.$samplename.$svname.R
done

cd ..
done
