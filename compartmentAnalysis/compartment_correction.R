#!/usr/bin/env Rscript

library(ggplot2)

dir="./02.CoolerLoadBalanceCallcompartments"
samplelist=list.files(dir,pattern="^TZX062")

r=0
p=list()

for (i in 1:length(samplelist)){
sample=samplelist[i]
filelist=list.files(paste(dir,sample,sep="/"),pattern="tsv$")

for (j in 1:length(filelist)){
chromosome=strsplit(filelist[j],split="[.|_]")[[1]][2]
data=read.table(paste(dir,sample,filelist[j],sep="/"),header=T,fill=T)

pclist=c(4,5,6)
for (k in 1:length(pclist)){
dataplot=data[,c(1,2,3,pclist[k])]
dataplot[is.na(dataplot)]=0
colnames(dataplot)=c("chr","start","end","value")
dataplot$pos=(dataplot[,2]+dataplot[,3])/2
dataplot$sign=ifelse(dataplot[["value"]]>=0,"positive","negative")

r=r+1
p[[r]]=list()

p[[r]]=ggplot(data=dataplot,mapping=aes(x=pos,y=value,fill=sign))+
geom_bar(stat="identity",position="dodge",width=100000)+
theme_classic()+
theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=15),axis.title.y=element_text(size=15),plot.title=element_text(hjust=0.5),legend.position="top",legend.key.size=unit(2.5,"pt"),legend.text=element_text(size=7.5))+
scale_fill_manual(values=c("blue","red"),name="",breaks=c("positive","negative"),labels=c("B compartment","A compartment"))+
scale_x_continuous(limits=c(0,65000000),breaks=seq(0,60000000,10000000),labels=seq(0,60,10))+
labs(title=paste0(sample," ",chromosome," PC",k),x=paste(sample,chromosome,"(Mb)"),y=paste0("PC",k," value"))

}
}
}

library(gridExtra)
pdf("compartments_correction.pdf",onefile=TRUE)
p
dev.off()
