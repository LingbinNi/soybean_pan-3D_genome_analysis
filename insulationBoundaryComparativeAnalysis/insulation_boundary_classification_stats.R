#!/usr/bin/env Rscript

dir="../"
filelist=list.files(dir,pattern="-InsulationBoundary.QueryCommon")

dat=data.frame()
for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="-")[[1]][2]
qrycom=read.table(paste(dir,paste("TZX544",sample,"InsulationBoundary.QueryCommon",sep="-"),sep="/"),header=F)
qryspe=read.table(paste(dir,paste("TZX544",sample,"InsulationBoundary.QuerySpecific",sep="-"),sep="/"),header=F)
refcom=read.table(paste(dir,paste("TZX544",sample,"InsulationBoundary.ReferenceCommon",sep="-"),sep="/"),header=F)
refspe=read.table(paste(dir,paste("TZX544",sample,"InsulationBoundary.ReferenceSpecific",sep="-"),sep="/"),header=F)
line=data.frame("Sample"=sample,"QueryUnmatch"=nrow(qryspe),"QueryMatch"=nrow(qrycom),"ReferenceUnmatch"=nrow(refspe),"ReferenceMatch"=nrow(refcom))
dat=rbind(dat,line)
}

write.csv(dat,"insulation_boundary_classification_stats.csv",row.names=F)
