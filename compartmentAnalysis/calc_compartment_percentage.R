#!/usr/bin/env Rscript

dir="./04.AB_correction"
filelist=list.files(dir,pattern="^TZX")

mat=matrix(nrow=20,ncol=27,dimnames=list(rep("rowname",20),rep("colname",27)))

for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="[.|_]")[[1]][1]
colnames(mat)[i]=sample
data=read.csv(paste(dir,filelist[i],sep="/"),header=T)

for (j in 1:length(levels(data[,1]))){
chr=levels(data[,1])[j]
rownames(mat)[j]=chr
datasub=data[which(as.character(data[,1])==chr),]
acompartment_num=nrow(datasub[which(as.character(datasub[,4])<0),])
bcompartment_num=nrow(datasub[which(as.character(datasub[,4])>0),])
acompartment_per=round(acompartment_num/(acompartment_num+bcompartment_num)*100,2)
bcompartment_per=round(bcompartment_num/(acompartment_num+bcompartment_num)*100,2)
mat[j,i]=acompartment_per
}

}
write.csv(mat,file="cal_compartments_pct.csv")
