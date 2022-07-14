#!/usr/bin/env Rscript

library(ggplot2)
options(scipen = 200)

dir="/01.InsulationBoundaryList/02.TAD"
filelist=list.files(dir,pattern="TAD$")

data=data.frame()
for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="-")[[1]][1]
tad=read.table(paste(dir,filelist[i],sep="/"),header=F,colClasses=c('character'))
colnames(tad)=c("chr","start","end")
tad$sample=rep(sample,nrow(tad))
tad$length=as.numeric(tad[,3])-as.numeric(tad[,2])
data=rbind(data,tad)
}

write.csv(data,file="tad_size.csv",row.names=F)
