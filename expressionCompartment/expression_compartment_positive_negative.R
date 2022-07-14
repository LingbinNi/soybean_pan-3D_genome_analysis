#!/usr/bin/env Rscript

data=read.csv("/00.DataBase/02.ExpressionFormatReferenceMapping/ReferenceMapping-Merge.csv",header=T)
data=data[grep("^Chr[0|1|2]",data[,2]),]

variable=read.csv("/03.Pan3DgenomeAnalysis/01.Pan3DgenomeAnalysis-ABpresence/ReferenceMapping-Statistics-Variable-ABpresence.csv",header=T)
variablesub=variable[,c(1,2,3,ncol(variable))]
variablepositive=variablesub[which(variablesub[,4]>0),]
variablenegative=variablesub[which(variablesub[,4]<0),]

for (j in 1:nrow(data)){
if (nrow( variablepositive[which(as.character(variablepositive[,1])==as.character(data[j,2]) & as.numeric(variablepositive[,2])<=as.numeric(data[j,3]) & as.numeric(variablepositive[,3])>as.numeric(data[j,3])),] )!=0){
data[j,32]="Positive"
}
else if (nrow( variablenegative[which(as.character(variablenegative[,1])==as.character(data[j,2]) & as.numeric(variablenegative[,2])<=as.numeric(data[j,3]) & as.numeric(variablenegative[,3])>as.numeric(data[j,3])),] )!=0){
data[j,32]="Negative"
}
else{
data[j,32]="None"
}
}

colnames(data)[32]="type"
write.csv(data,"expression_compartment_positive_negative.csv",row.names=F,quote=F)
