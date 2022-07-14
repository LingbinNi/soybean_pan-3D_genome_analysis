#!/usr/bin/env Rscript

library(ggplot2)

data=read.csv("calc_compartment_coefficient_of_variation.csv",header=T)
compartment=read.csv("/05.AB_correction/TZX544_AB_correction.csv",header=T)

data=data[,c(1,2,3,ncol(data))]
datacombine=merge(compartment,data,all.x=T)
datacombine$pos=(datacombine[,2]+datacombine[,3])/2

r=0
p=list()

chrlist=levels(datacombine[,1])
for (i in 1:length(chrlist)){

chr=chrlist[i]
datasub=datacombine[which(datacombine[,1]==chr),]

r=r+1
p[[r]] <- list()

p[[r]]=ggplot(data=datasub,aes(x=pos,y=TZX544,fill=ccv))+
geom_bar(stat="identity",position="dodge",width=100000)+
theme_classic()+
theme(legend.position="none",axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=15),axis.title.y=element_text(size=15))+
scale_x_continuous(limits=c(0,65000000),breaks=seq(0,60000000,10000000),labels=seq(0,60,10))+
scale_fill_gradient2(low='red',high='blue',midpoint=0)+
labs(x=paste(chr,"(Mb)"),y="E1")
}

plots=p
library(gridExtra)
pdf("ab_variable_compartments_distribution.pdf",width=20,height=12)
grid.arrange(grobs=plots,ncol=5,nrow=4)
dev.off()
