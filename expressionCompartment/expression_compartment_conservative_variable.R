#!/usr/bin/env Rscript

data=read.csv("/00.DataBase/02.ExpressionFormatReferenceMapping/ReferenceMapping-Merge.csv",header=T)
data=data[grep("^Chr[0|1|2]",data[,2]),]

compartment=read.csv("/02.ReferenceMapping-Statistics/ReferenceMapping-Statistics.csv",header=T)
conservedA=compartment[which(compartment[,31]==-27 & compartment[,32]==0),]
conservedB=compartment[which(compartment[,31]==0 & compartment[,32]==27),]
conserved0=compartment[which(compartment[,31]==0 & compartment[,32]==0),]
conservative=rbind(conservedA,conservedB,conserved0)

for (j in 1:nrow(data)){
conservativesub=conservative[which(as.character(conservative[,1])==as.character(data[j,2]) & as.numeric(conservative[,2])<=as.numeric(data[j,3]) & as.numeric(conservative[,3])>as.numeric(data[j,3])),]
if (nrow(conservativesub)==0){
data[j,32]="Variable"
}
else{
data[j,32]="Conservative"
}
}

colnames(data)[32]="type"
write.csv(data,"expression_compartment_conservative_variable.csv",row.names=F,quote=F)
