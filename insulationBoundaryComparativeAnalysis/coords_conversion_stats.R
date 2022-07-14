#!/usr/bin/env Rscript

library(ggplot2)

dir="../"
samplelist=list.files(dir,pattern="^TZX")

dat=data.frame()
for (i in 1:length(samplelist)){
sample=samplelist[i]
data=read.table(paste(dir,sample,paste(sample,"TZX544-InsulationBoundary",sep="-"),sep="/"),header=F)
count=nrow(data)
totaldata=read.table(paste("/01.InsulationBoundaryList/01.InsulationBoundary",paste(sample,"InsulationBoundary",sep="-"),sep="/"),header=F)
totalcount=nrow(totaldata)
percentage=round(count/totalcount*100,2)
dat=rbind(dat,data.frame("sample"=c(sample),"count"=c(count),"percentage"=c(percentage)))
}
write.csv(dat,file="coords_conversion_stats.csv",row.names=F)
