#!/usr/bin/env Rscript

library(clusterProfiler)

typelist=c("CC","MF","BP","All")
panlist=c("core","dispensable","private")

for (i in 1:length(typelist)){
gotype=typelist[i]
term2gene=read.table(paste("/01.BackGround/01.TERM2GENE/TERM2GENE.",gotype,".out",sep=""),sep="\t",quote="",header=F)
term2name=read.table(paste("/01.BackGround/02.TERM2NAME/TERM2NAME.",gotype,".out",sep=""),sep="\t",quote="",header=F)

for (j in 1:length(panlist)){
pantype=panlist[j]
genelist=read.table(paste("../02.GeneList/GeneList.",pantype,".out",sep=""),header=F)
geneset=as.vector(as.matrix(genelist))
result=enricher(geneset,TERM2GENE=term2gene,TERM2NAME=term2name)
write.table(as.data.frame(result),file=paste("Enricher.",gotype,".",pantype,".table",sep=""),row.names=F,quote=F,sep="\t")

pdf(paste("Enricher.",gotype,".",pantype,".pdf",sep=""),width=10,height=10)
p=dotplot(result,showCategory=10)
p
dev.off()
}
}
