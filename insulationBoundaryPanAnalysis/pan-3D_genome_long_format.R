#!/usr/bin/env Rscript

library(stringr)
options(scipen=200)

data=read.csv("Pan3Dgenome.csv",header=T)
data$Total=rowSums(data[,c(2:28)])
samplelist=colnames(data)[2:28]

for (i in 1:nrow(data)){
clustername=str_extract(data[i,1],"\\w+-Cluster-[0-9]+")
clusternamereplace=str_replace(data[i,1],"\\w+-Cluster-[0-9]+-","")
clusternamelist=strsplit(clusternamereplace,split="[:]")[[1]]
for (j in 1:length(clusternamelist)){
linename=clusternamelist[j]
linenamereplace=chartr(old="-",new="\t",linename)
cat(paste(paste(linenamereplace,clustername,data[i,29],sep="\t"),"\n",sep=""),file="Pan3DgenomeLongFormat.table",append=T)
}
}

data=read.table("Pan3DgenomeLongFormat.table",header=F)
data[which(data[,6]==27),7]="core"
data[which(data[,6]<27 & data[,6]>1),7]="dispensable"
data[which(data[,6]==1),7]="private"
write.table(data,"Pan3DgenomeLongFormat.table",row.names=F,col.names=F,sep="\t",quote=F)
