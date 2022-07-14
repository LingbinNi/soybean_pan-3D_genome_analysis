#!/usr/bin/env Rscript

dir="./04.AB_correction"
filelist=list.files(dir,pattern="^TZX")

for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="[.|_]")[[1]][1]
data=read.csv(paste(dir,filelist[i],sep="/"),header=T)
dat=data.frame()

chromosome=levels(data[,1])
for (j in 1:length(chromosome)){
chr=chromosome[j]
datasub=data[which(data[,1]==chr),]

for (k in 1:(nrow(datasub)-4)){
window=datasub[seq(k,k+4),]
positive=nrow(window[which(window[,4]>0),])
negative=nrow(window[which(window[,4]<0),])
if (positive>0 & negative>0){
line=data.frame(chrname = chr, startpoint = datasub[k,2], endpoint = datasub[k,3], type="Iregion")
dat=rbind(dat,line)
}
}

}
write.table(dat,file=paste0(sample,"_i_region_extract"),col.names=F,row.names=F,sep="\t",quote=F)
}
