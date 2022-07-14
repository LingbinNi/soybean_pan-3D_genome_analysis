#!/usr/bin/env Rscript

dir="./01.IregionExtract"
filelist=list.files(dir,pattern="_i_region_extract$")

mat=matrix(nrow=20,ncol=27,dimnames=list(rep("rowname",20),rep("colname",27)))

for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="[.|_]")[[1]][1]
colnames(mat)[i]=sample
data=read.table(paste(dir,filelist[i],sep="/"),header=F)

abcompartment=read.csv(paste0("./EigenvectorDecomposition/01.CallCompartments/04.AB_correction/",sample,"_AB_correction.csv"),header=T)

chromosome=levels(data[,1])
for (j in 1:length(chromosome)){
chr=chromosome[j]
rownames(mat)[j]=chr

#ablength
datasub=data[which(as.character(data[,1])==chr),]
ablength=sum(datasub[,3]-datasub[,2])
#compartmentlength
compartmentsub=abcompartment[which(abcompartment[,1]==chr & abcompartment[,4]!=0),]
chromlength=sum(compartmentsub[,3]-compartmentsub[,2])
#percentage
percentage=round(ablength/chromlength*100,2)
mat[j,i]=percentage
}
}

write.csv(mat,file="calc_i_region_percentage.csv")
