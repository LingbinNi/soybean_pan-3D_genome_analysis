#!/bin/bash

cat /DataBase/03.GeneFiles/sample.list.txt | while read LINE
do
str=$LINE
OLD_IFS="$IFS"
arr=($str)
IFS="$OLD_IFS"
old=${arr[1]}
new=${arr[0]}
newreplace=${new/-/}

echo '#!/usr/bin/env Rscript

snv=read.table("/01.SNP/29.pan-genome.SNP.txt",header=T)
indel=read.table("/02.Small-INDEL/29.pan-genome.Small-INDEL.txt",header=T)
snvsub=subset(snv,select=c("Chr","Pos","Ref","Alt","'$old'"))
indelsub=subset(indel,select=c("Chr","Start","end","Ref","Alt","'$old'"))

pav=read.table(paste("/03.StructuralVariationFormat/01.PAV/","'$newreplace'",".PAV.format.txt",sep=""),header=F)
inv=read.table(paste("/03.StructuralVariationFormat/02.INV/","'$newreplace'",".INV.format.txt",sep=""),header=F)
cnv=read.table(paste("/03.StructuralVariationFormat/03.CNV/","'$newreplace'",".CNV.format.txt",sep=""),header=F)
trans=read.table(paste("/03.StructuralVariationFormat/04.TRANS/","'$newreplace'",".TRANS.format.txt",sep=""),header=F)
sv=rbind(pav,inv,cnv,trans)

gff=read.table("/DataBase/03.GeneFiles/TZX-544.correct.gff3",header=F,sep="\t")
gffgene=gff[which(gff[,3]=="gene"),]

output=data.frame()
chrlist=levels(as.factor(gffgene[,1]))[1:20]
for (c in 1:length(chrlist)){
chr=chrlist[c]
gffgenechr=gffgene[which(gffgene[,1]==chr),]
snvsubchr=snvsub[which(snvsub[,1]==chr),]
indelsubchr=indelsub[which(indelsub[,1]==chr),]
svchr=sv[which(sv[,1]==chr),]

snvsubchr[,2]=as.numeric(snvsubchr[,2])
indelsubchr[,2]=as.numeric(indelsubchr[,2])
indelsubchr[,3]=as.numeric(indelsubchr[,3])
svchr[,3]=as.numeric(svchr[,3])
svchr[,4]=as.numeric(svchr[,4])

for (j in 1:nrow(gffgenechr)){
start=as.numeric(gffgenechr[j,4])
end=as.numeric(gffgenechr[j,5])
if (nrow(snvsubchr[which(snvsubchr[,2]>=start & snvsubchr[,2]<=end & snvsubchr[,5]!="."),]) == 0){
if (nrow(indelsubchr[which( (indelsubchr[,2]>=start & indelsubchr[,2]<=end & indelsubchr[,6]!=".") | (indelsubchr[,3]>=start & indelsubchr[,3]<=end & indelsubchr[,6]!=".") | (indelsubchr[,2]<=start & indelsubchr[,3]>=end & indelsubchr[,6]!=".") ),]) == 0){
if (nrow(svchr[which( (svchr[,3]>=start & svchr[,3]<=end) | (svchr[,4]>=start & svchr[,4]<=end) | (svchr[,3]<=start & svchr[,4]>=end) ),]) == 0){
gffgenechr[j,10]="NonVariationGene"
}
}
}
}

output=rbind(output,gffgenechr)
}

write.table(output,paste("'$new'","-GeneClassification",sep=""),row.names=F,col.names=F,quote=F,sep="\t")' > $new-GeneClassification.R
###run###
chmod 755 $new-GeneClassification.R
echo $new-GeneClassification
bsub -n 1 -q fat -J $new-GeneClassification -o $new-GeneClassification.o -e $new-GeneClassification.e \
Rscript $new-GeneClassification.R
done
