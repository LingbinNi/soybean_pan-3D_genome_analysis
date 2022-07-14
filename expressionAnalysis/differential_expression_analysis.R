#!/usr/bin/env Rscript

library(DESeq2)

dir="/06.DESeq2/01.PrepDE"
samplelist=list.files(dir,pattern="^TZX")

for (i in 1:length(samplelist)){
sample=samplelist[i]
dir.create(sample)
setwd(sample)
#countData
countData=as.matrix(read.csv(paste(dir,sample,"transcript_count_matrix.csv",sep="/"),row.names="transcript_id",check.names=F))
colnames(countData)=sub("-","",paste(regmatches(colnames(countData),regexpr("^TZX-[0-9]+",colnames(countData))),c("A","B","A","B"),sep=""))
countData=countData[,c(grep("TZX544",colnames(countData)),grep(sample,colnames(countData)))]
#colData
colData=data.frame(row.names=colnames(countData),condition=regmatches(colnames(countData),regexpr("^TZX[0-9]+",colnames(countData))))
colData$condition=factor(colData$condition,levels=c("TZX544",sample))
#dds
ddsFullCountTable=DESeqDataSetFromMatrix(countData=countData,colData=colData,design = ~ condition)
dds=DESeq(ddsFullCountTable)
#result
res=results(dds,contrast=c("condition",sample,"TZX544"))
resOrdered=res[order(res$padj),]
write.csv(resOrdered,"DESeq2.csv")
setwd("..")
}
