#!/usr/bin/env Rscript

dir="/01.InsulationBoundary"
filelist=list.files(dir,pattern="^TZX")

dat=data.frame()
for (i in 1:length(filelist)){
sample=strsplit(filelist[i],split="-")[[1]][1]
ib=read.table(paste(dir,filelist[i],sep="/"),header=F)
compartment=read.csv(paste("/SelfMapping_AB_correction/",sample,"_AB_correction.csv",sep=""),header=T)
chrlist=levels(compartment[,1])
compartmentborder=data.frame()
for (c in 1:length(chrlist)){
compartmentsub=compartment[which(compartment[,1]==chrlist[c]),]
for (l in 1:(nrow(compartmentsub)-1)){
if ((compartmentsub[l,4]*compartmentsub[l+1,4]<0)){
compartmentsub[l,5]="CompartmentBorder"
compartmentsub[l+1,5]="CompartmentBorder"
}
}
compartmentborder=rbind(compartmentborder,compartmentsub)
}
colnames(compartmentborder)=c("chr","start","end","E1","type")
compartmentmerge=compartmentborder

for (j in 1:nrow(ib)){
compartmentmerge[which(compartmentmerge[,1]==ib[j,1] & compartmentmerge[,2]<=ib[j,2] & compartmentmerge[,3]>=ib[j,3]),6]="InsulationBoundary"
}

borderib=nrow(compartmentmerge[which(compartmentmerge[,5]=="CompartmentBorder" & compartmentmerge[,6]=="InsulationBoundary"),])
bordernonib=nrow(compartmentmerge[which(compartmentmerge[,5]=="CompartmentBorder" & is.na(compartmentmerge[,6])),])
nonborderib=nrow(compartmentmerge[which(is.na(compartmentmerge[,5]) & compartmentmerge[,6]=="InsulationBoundary"),])
nonbordernonib=nrow(compartmentmerge[which(is.na(compartmentmerge[,5]) & is.na(compartmentmerge[,6])),])

line=data.frame(BorderIB=borderib,BorderNonIB=bordernonib,NonBorderIB=nonborderib,NonBorderNonIB=nonbordernonib)
dat=rbind(dat,line)
}

write.csv(dat,"InsulationBoundaryAndCompartmentBorderFisherExactTest.csv",row.names=F)

fisher.test(matrix(c(sum(dat[,1]),sum(dat[,2]),sum(dat[,3]),sum(dat[,4])),nrow=2))
