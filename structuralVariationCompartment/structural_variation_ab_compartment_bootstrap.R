#!/usr/bin/env Rscript

library(ggplot2)

dir="./00.StructuralVariationNumber"
svlist=list.files(dir,pattern="^0")

r=0
p=list()

for (i in 1:length(svlist)){
svname=strsplit(svlist[i],split="[.|-]")[[1]][2]
filelist=list.files(paste(dir,svlist[i],sep="/"),pattern="csv$")

for (j in 1:length(filelist)){
sample=strsplit(filelist[j],split="[.|-]")[[1]][2]
data=read.csv(paste(dir,svlist[i],filelist[j],sep="/"),header=T)
#observed
observed=sum(data[which(data[,4]<0),5])
#expected
n=nrow(data[which(data[,4]<0),])
Mboot <- replicate(10000, expr = {
    y <- sample(data[,5], size = n, replace = TRUE)
    sum(y)
})
#plot
dataplot=data.frame(z=Mboot)
zvalue=(observed-mean(Mboot))/(sd(Mboot))
r=r+1
p[[r]]=list()
p[[r]]=ggplot(dataplot,aes(x=z))+
geom_histogram(binwidth=15,color="black",fill="white")+
scale_y_continuous(expand=c(0,0))+
scale_x_continuous(limits=c(min(Mboot)-(max(Mboot)-min(Mboot))/4,max(Mboot)+(max(Mboot)-min(Mboot))/4))+
theme_classic()+
theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=15),axis.title.y=element_text(size=15))+
labs(title=paste(svname,sample,paste("observe",observed,sep="="),paste("zvalue",zvalue,sep="=")),x="",y="Count")

}
}

library(gridExtra)
pdf("Plot.pdf",width=10,height=10,onefile=TRUE)
p
dev.off()
