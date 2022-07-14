#!/usr/bin/env Rscript

library(dplyr)

data=read.csv("../../02.PositiveNegativeExpression/expression_compartment_positive_negative.csv",header=T)
data=data[which(data$type=="Positive" | data$type=="Negative"),]

variable=read.csv("/03.Pan3DgenomeAnalysis/01.Pan3DgenomeAnalysis-ABpresence/ReferenceMapping-Statistics-Variable-ABpresence.csv",header=T)
variablesub=variable[,c(1,2,3,ncol(variable))]
variablepositive=variablesub[which(variablesub[,4]>0),]
variablenegative=variablesub[which(variablesub[,4]<0),]

#positive
variablepositiveorder=variablepositive[order(variablepositive[,4]),]
PositiveHigh=variablepositiveorder[c(floor(nrow(variablepositive)-nrow(variablepositive)*0.3):nrow(variablepositive)),]
PositiveLow=variablepositiveorder[c(1:floor(nrow(variablepositive)*0.3)),]
PositiveMedian=anti_join(variablepositive,rbind(PositiveHigh,PositiveLow))
#negative
variablenegativeorder=variablenegative[order(abs(variablenegative[,4])),]
NegativeHigh=variablenegativeorder[c(floor(nrow(variablenegative)-nrow(variablenegative)*0.3):nrow(variablenegative)),]
NegativeLow=variablenegativeorder[c(1:floor(nrow(variablenegative)*0.3)),]
NegativeMedian=anti_join(variablenegative,rbind(NegativeHigh,NegativeLow))

for (j in 1:nrow(data)){
if (nrow(PositiveHigh[which(as.character(PositiveHigh[,1])==as.character(data[j,2]) & as.numeric(PositiveHigh[,2])<=as.numeric(data[j,3]) & as.numeric(PositiveHigh[,3])>as.numeric(data[j,3])),])!=0){
data[j,32]="PositiveHigh"
}
else if (nrow(PositiveLow[which(as.character(PositiveLow[,1])==as.character(data[j,2]) & as.numeric(PositiveLow[,2])<=as.numeric(data[j,3]) & as.numeric(PositiveLow[,3])>as.numeric(data[j,3])),])!=0){
data[j,32]="PositiveLow"
}
else if (nrow(PositiveMedian[which(as.character(PositiveMedian[,1])==as.character(data[j,2]) & as.numeric(PositiveMedian[,2])<=as.numeric(data[j,3]) & as.numeric(PositiveMedian[,3])>as.numeric(data[j,3])),])!=0){
data[j,32]="PositiveMedian"
}
else if (nrow(NegativeHigh[which(as.character(NegativeHigh[,1])==as.character(data[j,2]) & as.numeric(NegativeHigh[,2])<=as.numeric(data[j,3]) & as.numeric(NegativeHigh[,3])>as.numeric(data[j,3])),])!=0){
data[j,32]="NegativeHigh"
}
else if (nrow(NegativeLow[which(as.character(NegativeLow[,1])==as.character(data[j,2]) & as.numeric(NegativeLow[,2])<=as.numeric(data[j,3]) & as.numeric(NegativeLow[,3])>as.numeric(data[j,3])),])!=0){
data[j,32]="NegativeLow"
}
else if (nrow(NegativeMedian[which(as.character(NegativeMedian[,1])==as.character(data[j,2]) & as.numeric(NegativeMedian[,2])<=as.numeric(data[j,3]) & as.numeric(NegativeMedian[,3])>as.numeric(data[j,3])),])!=0){
data[j,32]="NegativeMedian"
}
else{
data[j,32]="None"
}
}

colnames(data)[32]="class"
write.csv(data,"expression_compartment_high_median_low.csv",row.names=F,quote=F)
