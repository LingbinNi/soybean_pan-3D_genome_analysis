#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)
library(viridis)

#contribution
contribution=read.csv("StructuralVariationAnalysisContribution.csv",header=T)
#effect
effect=read.csv("StructuralVariationAnalysisEffect.csv",header=T)
effect$total=effect$common+effect$specific
effect$effect=round(effect$specific/effect$total,2)
effect=effect[,c(1,2,5,6)]
colnames(effect)=c("sv","type","total","effect")
#merge
data=merge(contribution,effect)
data$name=paste0(data$sv,"-",data$type," ","(",data$total,")")
data$name=factor(data$name,levels=data[order(data$specificsv/(data$specificnsv+data$specificsv)),10])
data$contribution=round(data$specificsv/(data$specificsv+data$specificnsv)*100,2)
datalong=melt(data[,c(3,4,5,6,7,9,10,11)],id.vars=c("name","p","contribution","effect"),variable.name="class",value.name="count")

####################plot main
pdf("StructuralVariationAnalysisEffectContribution-Main.pdf",width=12.5,height=15)
ggplot(datalong,aes(x=name,y=count,fill=class))+
geom_bar(stat="identity",width=0.75,position='fill')+
scale_y_continuous(expand=c(0,0))+
scale_fill_manual(values=c('#ff9c9c','#c5afe0','#ace1af','#ffe6bd'))+
labs(title="",x="",y="Fraction (%)")+
theme_bw()+
theme(panel.grid=element_blank(),legend.position="none",axis.text.x=element_text(size=30),axis.text.y=element_text(size=30),axis.title.x=element_text(size=30),axis.title.y=element_text(size=30))+
coord_flip()
dev.off()

####################plot contribution
pdf("StructuralVariationAnalysisEffectContribution-Contribution.pdf",width=12.5,height=15)
ggplot(data,aes(x=name,y=1,fill=contribution))+
geom_bar(stat="identity",width=0.75)+
geom_text(aes(x=name,y=0.5,label=contribution),color="black",hjust=0.5,size=10)+
scale_y_continuous(expand=c(0,0))+
scale_fill_gradient(low="white",high="#797EE1")+
labs(title="",x="",y="")+
theme_bw()+
theme(panel.grid=element_blank(),axis.text.x=element_text(size=30),axis.text.y=element_text(size=30),axis.title.x=element_text(size=30),axis.title.y=element_text(size=30))+
coord_flip()
dev.off()

####################plot effect
pdf("StructuralVariationAnalysisEffectContribution-Effect.pdf",width=12.5,height=15)
ggplot(data,aes(x=name,y=1,fill=effect))+
geom_bar(stat="identity",width=0.75)+
scale_y_continuous(expand=c(0,0))+
scale_fill_viridis(limits=c(0.25,1),breaks=seq(0.25,1,0.25),option="turbo")+
geom_text(aes(x=name,y=0.5,label=effect),color="black",hjust=0.5,size=10)+
labs(title="",x="",y="")+
theme_bw()+
theme(panel.grid=element_blank(),axis.text.x=element_text(size=30),axis.text.y=element_text(size=30),axis.title.x=element_text(size=30),axis.title.y=element_text(size=30))+
coord_flip()
dev.off()
