#!/usr/bin/env Rscript

dir="/05.AB_correction"
filelist=list.files(dir,pattern="^TZX")

dat=data.frame()

tzx544=read.csv(paste(dir,"TZX544_AB_correction.csv",sep="/"),header=T)
col=tzx544[,c(1,2,3)]

dat=col

for (i in 1:length(filelist)){
tzxsample=read.csv(paste(dir,filelist[i],sep="/"),header=T)
ab=as.data.frame(tzxsample[,4])
colnames(ab)=colnames(tzxsample)[4]
dat=cbind(dat,ab)
}

datreplace=dat
datreplacesub=datreplace[,-c(1,2,3)]
datreplacesub[is.na(datreplacesub)]=0
datreplacesub[datreplacesub<0]=-1
datreplacesub[datreplacesub>0]=1
datreplacecol=datreplace[,c(1,2,3)]
datreplace=cbind(datreplacecol,datreplacesub)


datreplace$Acompartment=rowSums(datreplace[,c(4:30)]<0)*-1
datreplace$Bcompartment=rowSums(datreplace[,c(4:30)]>0)

#statistics
conservedA=nrow(datreplace[which(datreplace[,31]==-27 & datreplace[,32]==0),])
conservedB=nrow(datreplace[which(datreplace[,31]==0 & datreplace[,32]==27),])
conserved0=nrow(datreplace[which(datreplace[,31]==0 & datreplace[,32]==0),])
conserved=conservedA+conservedB+conserved0

variableA=nrow(datreplace[which(datreplace[,31]<0 & datreplace[,31]>-27 & datreplace[,32]==0),])
variableB=nrow(datreplace[which(datreplace[,32]>0 & datreplace[,32]<27 & datreplace[,31]==0),])
variableAB=nrow(datreplace[which(datreplace[,31]<0 & datreplace[,31]>-27 & datreplace[,32]>0 & datreplace[,32]<27),])
variable=variableA+variableB+variableAB

write.csv(datreplace,"compartment_pan_analysis.csv",row.names=F,quote=F)
