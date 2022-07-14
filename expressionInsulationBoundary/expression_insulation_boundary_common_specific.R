#!/usr/bin/env Rscript

dir="/01.3DgenomeExpression/01.IBNonIBExpression/01.Transcript_IBNonIB_Type"
filelist=list.files(dir,pattern="TZX693-Transcript_IBNonIB_Type$")

for (i in 1:length(filelist)){
filename=filelist[i]
sample=strsplit(filename,split="[-]")[[1]][1]
data=read.table(paste(dir,filename,sep="/"),header=F)
samplecommon=read.table(paste0("/01.Comparative3Dgenome/01.Comparative3Dgenome-Stringent/03.InsulationBoundaryClassification/TZX544-",sample,"-InsulationBoundary.QueryCommon"),header=F)

for (j in 1:nrow(data)){
samplecommonsub=samplecommon[which(as.character(samplecommon[,1])==as.character(data[j,2]) & as.numeric(samplecommon[,2])<=as.numeric(data[j,3]) & as.numeric(samplecommon[,3])>as.numeric(data[j,3])),]
if (nrow(samplecommonsub)==0){
data[j,9]="Specific"
}
else{
data[j,9]="Common"
}
}

write.table(data,paste(sample,"expression_insulation_boundary_common_specific",sep="-"),sep="\t",col.names=F,row.names=F,quote=F)
}
