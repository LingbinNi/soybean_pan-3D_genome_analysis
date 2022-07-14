#!/usr/bin/env Rscript

###step1: calculation
dir="/1.bedtools_gc"
filelist=list.files(dir,pattern="^TZX")

for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="[_|.]")[[1]][1]
window=read.table(paste(dir,filelist[i],sep="/"),header=F)

repeatlist=list.files("/DataBase/repeatmasker-merge",pattern=sample)
for (j in 1:length(repeatlist)){
repeattype=strsplit(repeatlist[j],split="[_|.]")[[1]][2]
repeatdata=read.table(paste("/DataBase/repeatmasker-merge",repeatlist[j],sep="/"),header=F)

for (i in 1:nrow(window)){
chr=window[i,1]
start=window[i,2]
end=window[i,3]
repeatsub=repeatdata[which(as.character(repeatdata[,1])==as.character(chr) & repeatdata[,3]>start & repeatdata[,2]<end),]

if (nrow(repeatsub)==0){
cat(paste(paste(chr,start,end,0,sep="\t"),"\n",sep=""),file=paste0(sample,"_",repeattype,"_repeat_ratio_statistics_window"),append=T)
}
else{
if (repeatsub[1,2]<start & repeatsub[nrow(repeatsub),3]>end){
region=sum(repeatsub[,3]-repeatsub[,2])-(start-repeatsub[1,2])-(repeatsub[nrow(repeatsub),3]-end)
}
if (repeatsub[1,2]>=start & repeatsub[nrow(repeatsub),3]<=end){
region=sum(repeatsub[,3]-repeatsub[,2])
}
if (repeatsub[1,2]<start & repeatsub[nrow(repeatsub),3]<=end){
region=sum(repeatsub[,3]-repeatsub[,2])-(start-repeatsub[1,2])
}
if (repeatsub[1,2]>=start & repeatsub[nrow(repeatsub),3]>end){
region=sum(repeatsub[,3]-repeatsub[,2])-(repeatsub[nrow(repeatsub),3]-end)
}
percentage=round(region/(end-start)*100,2)
cat(paste(paste(chr,start,end,percentage,sep="\t"),"\n",sep=""),file=paste0(sample,"_",repeattype,"_repeat_ratio_statistics_window"),append=T)
}
}
}
}

###step2: average
options(scipen=200)

dir="/01.InsulationBoundary"
filelist=list.files(dir,pattern="^TZX")

for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="-")[[1]][1]
data=read.table(paste(dir,filelist[i],sep="/"),header=F)
data=data[,c(1,2,3)]

repeatlist=list.files("/RepeatPercentageClassification-R/01.repeat_percentage",pattern=sample)
for (k in 1:length(repeatlist)){
repeattype=strsplit(repeatlist[k],split="_")[[1]][2]
repeatpercentage=read.table(paste("../01.repeat_percentage",repeatlist[k],sep="/"),header=F)

for (j in seq(-500000,500000,25000)){
datareplace=data.frame(data[,1],data[,2]+j,data[,3]+j)
colnames(datareplace)=c("V1","V2","V3")
repeatpercentagesub=merge(repeatpercentage,datareplace)
repeatpercentagesubna=na.omit(repeatpercentagesub)
average=mean(repeatpercentagesubna[,4])
cat(paste0(j,",",average,"\n"),file=paste(sample,repeattype,"average.csv",sep="-"),append=T)
}
}
}
