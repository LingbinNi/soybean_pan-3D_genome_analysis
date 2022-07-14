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

reference=read.table("/01.InsulationBoundaryList/01.InsulationBoundary/TZX544-InsulationBoundary",header=F,sep="\t")
reference=reference[which(reference[,1] %in% c(levels(as.factor(reference[,1]))[1:20])),]
query=read.table(paste("/01.InsulationBoundaryList/01.InsulationBoundary/","'$sample'","-InsulationBoundary",sep=""),header=F,sep="\t")
query=query[which(query[,1] %in% c(levels(as.factor(query[,1]))[1:20])),]
sv=read.table("'$file'",header=F)

for (i in 1:nrow(sv)){
#reference
if (nrow( reference[which( (as.character(sv[i,1])==as.character(reference[,1]) & as.numeric(sv[i,3])>as.numeric(reference[,2]) & as.numeric(sv[i,3])<as.numeric(reference[,3])) | (as.character(sv[i,1])==as.character(reference[,1]) & as.numeric(sv[i,4])>as.numeric(reference[,2]) & as.numeric(sv[i,4])<as.numeric(reference[,3])) | (as.character(sv[i,1])==as.character(reference[,1]) & as.numeric(sv[i,3])<as.numeric(reference[,2]) & as.numeric(sv[i,4])>as.numeric(reference[,3]))),] ) == 0){
sv[i,8]="NBA"
}
else if (nrow( reference[which( as.character(sv[i,1])==as.character(reference[,1]) & as.numeric(sv[i,3])<as.numeric(reference[,2]) & as.numeric(sv[i,4])>as.numeric(reference[,3])),] ) != 0){
sv[i,8]="ABA"
}
else{
sv[i,8]="PBA"
}
#query
if (nrow( query[which( (as.character(sv[i,5])==as.character(query[,1]) & as.numeric(sv[i,6])>as.numeric(query[,2]) & as.numeric(sv[i,6])<as.numeric(query[,3])) | (as.character(sv[i,5])==as.character(query[,1]) & as.numeric(sv[i,7])>as.numeric(query[,2]) & as.numeric(sv[i,7])<as.numeric(query[,3])) | (as.character(sv[i,5])==as.character(query[,1]) & as.numeric(sv[i,6])<as.numeric(query[,2]) & as.numeric(sv[i,7])>as.numeric(query[,3]))),] ) == 0){
sv[i,9]="NBA"
}
else if (nrow( query[which( as.character(sv[i,5])==as.character(query[,1]) & as.numeric(sv[i,6])<as.numeric(query[,2]) & as.numeric(sv[i,7])>as.numeric(query[,3]) ),] ) != 0){
sv[i,9]="ABA"
}
else{
sv[i,9]="PBA"
}
}

write.table(sv,file=paste("'$sample'","'$sv'","StructuralVariationClassification",sep="."),sep="\t",quote=F,col.names=F,row.names=F)' > $sample-$sv.R
###run###
chmod 755 $sample-$sv.R
echo $sample-$sv
bsub -n 1 -q lowl -J $sample-$sv -o $sample-$sv.o -e $sample-$sv.e \
Rscript $sample-$sv.R
done

cd ..
done
