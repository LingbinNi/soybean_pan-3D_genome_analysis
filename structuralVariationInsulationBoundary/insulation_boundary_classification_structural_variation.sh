#!/bin/bash

for dir in $(ls -d /03.StructuralVariationFormat/0*)
do
dirname=$(basename $dir)
mkdir $dirname
cd $dirname

for file in $(ls $dir/TZX*)
do
filename=$(basename $file .format.txt)
sample=${filename%%.*}
sv=${dirname#*.}
echo '#!/usr/bin/env Rscript

commondata=read.table("/03.InsulationBoundaryClassification/TZX544-'$sample'-InsulationBoundary.ReferenceCommon",header=F)
commondata$type=rep("ReferenceCommon",nrow(commondata))
specificdata=read.table("/03.InsulationBoundaryClassification/TZX544-'$sample'-InsulationBoundary.ReferenceSpecific",header=F)
specificdata$type=rep("ReferenceSpecific",nrow(specificdata))
data=rbind(commondata,specificdata)
data=data[order(data[,1],data[,2],data[,3]),]

sv=read.table("'$file'",header=F)

dataout=data

for (j in 1:nrow(dataout)){
if (nrow(sv[which(sv[,1]==dataout[j,1] & sv[,3]<=dataout[j,2] & sv[,4]>=dataout[j,3]),])!=0){
dataout[j,5]="ABA"
}
else if (nrow(sv[which( (sv[,1]==dataout[j,1] & sv[,3]>dataout[j,2] & sv[,3]<dataout[j,3]) | (sv[,1]==dataout[j,1] & sv[,4]>dataout[j,2] & sv[,4]<dataout[j,3]) ),])!=0){
dataout[j,5]="PBA"
}
else{
dataout[j,5]="NBA"
}

write.table(dataout,file=paste("'$sample'","'$sv'","InsulationBoundaryClassification",sep="."),sep="\t",quote=F,col.names=F,row.names=F)
}' > $sample-$sv.R
###run###
chmod 755 $sample-$sv.R
echo $sample-$sv
bsub -n 1 -q lowl -J $sample-$sv -o $sample-$sv.o -e $sample-$sv.e \
Rscript $sample-$sv.R
done

cd ..
done
