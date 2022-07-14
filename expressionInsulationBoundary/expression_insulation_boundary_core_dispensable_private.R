#!/usr/bin/env Rscript

pangenome=read.table("/05.Pan3Dgenome/Pan3DgenomeLongFormat.table",header=F)

dir="/01.3DgenomeExpression/01.IBNonIBExpression/01.Transcript_IBNonIB_Type"
filelist=list.files(dir,pattern="-Transcript_IBNonIB_Type$")

for (i in 1:length(filelist)){
filename=filelist[i]
sample=strsplit(filename,split="[-]")[[1]][1]
data=read.table(paste(dir,filename,sep="/"),header=F)
pangenomesample=pangenome[which(as.character(pangenome[,1])==sample),]

for (j in 1:nrow(data)){
pangenomesamplesub=pangenomesample[which(as.character(pangenomesample[,2])==as.character(data[j,2]) & as.numeric(pangenomesample[,3])<=as.numeric(data[j,3]) & as.numeric(pangenomesample[,4])>as.numeric(data[j,3])),]
if (nrow(pangenomesamplesub)==0){
data[j,9]="None"
}
else{
data[j,9]=as.character(pangenomesamplesub[,7])
}
}

write.table(data,paste(sample,"expression_insulation_boundary_core_dispensable_private",sep="-"),sep="\t",col.names=F,row.names=F,quote=F)
}
