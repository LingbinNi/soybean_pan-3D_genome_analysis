#!/usr/bin/env Rscript

library(ggplot2)

samplelist=c("TZX544","TZX250","TZX248","TZX230","TZX358","TZX2019","TZX1055","TZX1058","TZX062","TZX693","TZX1029","TZX1024","TZX1246","TZX2379","TZX2441","TZX1145","TZX1271","TZX1230","TZX1744","TZX1297","TZX1720","TZX1695","TZX210","TZX1601","TZX1399","TZX1436","TZX2139")

#data read
data=read.table("Pan3Dgenome-Dispensable-Example.table",header=F)
data$ib=paste(data[,9],data[,10],data[,11],sep="-")
data$sv=paste(data[,7],data[,1],data[,2],data[,3],sep="-")
#data select
ibfre=as.data.frame(table(data$ib))
ibsub=as.character(ibfre[which(ibfre[,2]==max(ibfre[,2])),1])
datasub=data[which(data$ib==ibsub),]
colnames(datasub)=c("chr1","start1","end1","chr2","start2","end2","svsubtype","sample","ibchr","ibstart","ibend","ib","sv")
#data format
###ib
ib=read.table("/00.DataBase/InsulationBoundary/01.InsulationBoundary/TZX544-InsulationBoundary",header=F)
#ib=read.table("TZX544-InsulationBoundary",header=F)
ibchr=as.character(datasub[1,9])
ibstart=datasub[1,10]
ibend=datasub[1,11]
regionchr=ibchr
regionstart=ib[which(ib[,1]==ibchr & ib[,2]==ibstart & ib[,3]==ibend)-1,2]
regionend=ib[which(ib[,1]==ibchr & ib[,2]==ibstart & ib[,3]==ibend)+1,3]
###sv
sv=read.table("/00.DataBase/StructuralVariation/08.StructuralVariationCombine/StructuralVariationCombine.table",header=F)
svsub=sv[which( (sv[,1]==regionchr & sv[,2]>regionstart & sv[,2]<regionend) | (sv[,1]==regionchr & sv[,3]>regionstart & sv[,3]<regionend) | (sv[,1]==regionchr & sv[,2]<=regionstart & sv[,3]>=regionend) ),]
svsample=levels(as.factor(as.character(svsub[,8])))
for (i in 1:length(samplelist)){
if (!(samplelist[i]%in%svsample)){
line=data.frame(V1=regionchr,V2=regionstart,V3=regionend,V4=NA,V5=NA,V6=NA,V7=NA,V8=samplelist[i])
svsub=rbind(svsub,line)
}
}
for (i in 1:length(samplelist)){
svsub[which(svsub[,8]==samplelist[i]),9]=28-i
}
svsub[which(svsub[,2]<regionstart),2]=regionstart
svsub[which(svsub[,3]>regionend),3]=regionend
svsub[which(svsub[,7]=="PAV"|svsub[,7]=="PRESENCE"|svsub[,7]=="ABSENCE"),10]="PAV"
svsub[which(svsub[,7]=="INV"),10]="INV"
svsub[which(svsub[,7]=="CNV-NQ"|svsub[,7]=="CNV-NR"),10]="CNV"
svsub[which(svsub[,7]=="TRANS-intra"|svsub[,7]=="TRANS-inter"),10]="TRANS"
svsub[which(is.na(svsub[,7])),10]=NA
colnames(svsub)=c("chr1","start1","end1","chr2","start2","end2","svsubtype","sample","pos","svtype")
#data plot
pdf("haplotype_plot.pdf",width=6,height=20)
ggplot(svsub)+
geom_segment(aes(x=regionstart,xend=regionend,y=pos,yend=pos),size=5,colour="#c3effc")+
geom_segment(aes(x=start1,xend=end1,y=pos,yend=pos,colour=svtype),size=5)+
geom_text(aes(x=regionend,y=pos,label=sample),hjust=0)+
scale_x_continuous(expand=c(0,0),limits=c(regionstart,regionend+(regionend-regionstart)/10),breaks=c(regionstart,regionend),labels=round(c(regionstart,regionend)/1000000,2))+
scale_y_continuous(expand=c(0,0),limits=c(0,27),breaks=seq(1:27),labels=seq(1:27))+
labs(x="",y="")+
theme_bw()+
theme(legend.position="none",panel.grid=element_blank(),axis.text.x=element_text(size=10),axis.text.y=element_text(size=10),axis.title.x=element_text(size=10),axis.title.y=element_text(size=10))
dev.off()
