#!/usr/bin/env Rscript

library(pheatmap)

data=read.csv("../02.ReferenceMapping-Statistics/ReferenceMapping-Statistics.csv",header=T)

datasub=data[which(data[,31]!=0 | data[,32]!=0),]
datasub=datasub[which(datasub[,31]!=-27 & datasub[,32]!=27),]

dataorder=datasub[order(datasub[,31],datasub[,32]),]

dataordersub=dataorder[,c(4:30)]
dataordersub[(nrow(dataordersub)+1),]=colSums(dataordersub==0)
dataordersuborder=dataordersub[,order(dataordersub[nrow(dataordersub),])]

dataplot=dataordersuborder[-nrow(dataordersuborder),]

library(stringr)
oldnames=c("TZX544","TZX250","TZX248","TZX230","TZX358","TZX2019","TZX1055","TZX1058","TZX062","TZX693","TZX1029","TZX1024","TZX1246","TZX2379","TZX2441","TZX1145","TZX1271","TZX1230","TZX1744","TZX1297","TZX1720","TZX1695","TZX210","TZX1601","TZX1399","TZX1436","TZX2139")
newnames=c("ZH13","SoyW01","SoyW02","SoyW03","SoyL01","SoyL02","SoyL03","SoyL04","SoyL05","SoyL06","SoyL07","SoyL08","SoyL09","SoyC01","SoyC02","SoyC03","SoyC04","SoyC05","SoyC06","SoyC07","SoyC08","SoyC09","SoyC10","SoyC11","SoyC12","SoyC13","SoyC14")
names(newnames)=oldnames
colnames(dataplot)=str_replace_all(colnames(dataplot),newnames)

pdf("ab_variable_compartments_distribution.pdf",width=12,height=10)
pheatmap(as.matrix(t(dataplot)),show_rownames=T,show_colnames=F,cluster_rows=F,cluster_cols=F,color=c("#F04E2B","grey","#608DC9"))
dev.off()
