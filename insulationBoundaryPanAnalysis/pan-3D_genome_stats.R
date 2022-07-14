#!/usr/bin/env Rscript

data=read.csv("/05.Pan3Dgenome/Pan3Dgenome.csv",header=T)
data$Total=rowSums(data[,c(2:28)])
write.csv(data,"pan-3D_genome_stats.csv",row.names=F,quote=F)

core=nrow(data[which(data$Total==27),])
dispensable=nrow(data[which(data$Total<27 & data$Total>1),])
private=nrow(data[which(data$Total==1),])
print(paste("core:",core))
print(paste("dispensable:",dispensable))
print(paste("private:",private))
