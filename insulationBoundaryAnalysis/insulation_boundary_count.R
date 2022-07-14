#!/usr/bin/env Rscript

chromlength=read.csv("ChromosomeLength.csv",header=T)

dir="/03.InsulationScore"
samplelist=list.files(dir,pattern="^TZX")

for (i in 1:length(samplelist)){
sample=samplelist[i]
chrlist=list.files(paste(dir,sample,sep="/"),pattern="^Chr")
for (j in 1:length(chrlist)){
chr=chrlist[j]
file=list.files(paste(dir,sample,chr,sep="/"),pattern="boundaries$")
data=read.table(paste(dir,sample,chr,file,sep="/"),header=T)
count=nrow(data)
length=chromlength[which(chromlength[,3]==sample&chromlength[,1]==chr),2]
countnorm=count/length*1000000
cat(paste0(sample,",",chr,",",countnorm,"\n"),file="insulation_boundary_count.csv",append=T)
}
}
