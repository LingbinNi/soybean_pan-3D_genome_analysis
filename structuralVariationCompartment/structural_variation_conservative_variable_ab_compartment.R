#!/usr/bin/env Rscript

dir="/03.StructuralVariationFormat"
svlist=list.files(dir,pattern="^0")

output=data.frame()
for (i in 1:length(svlist)){
svname=strsplit(svlist[i],split="[.|-]")[[1]][2]
filelist=list.files(paste(dir,svlist[i],sep="/"),pattern="^TZX")

for (j in 1:length(filelist)){
sample=strsplit(filelist[j],split="[.|-]")[[1]][1]
sv=read.table(paste(dir,svlist[i],filelist[j],sep="/"),header=F)
compartment=read.table(paste("/00.DataBase/02.ABcompartment-Comparative3Dgenome",paste(sample,"Comparative3Dgenome-Compare",sep="-"),sep="/"),header=T)

for (k in 1:nrow(compartment)){
if (nrow(sv[which( (as.character(sv[,1])==as.character(compartment[k,1]) & as.numeric(sv[,3])>=as.numeric(compartment[k,2]) & as.numeric(sv[,3])<=as.numeric(compartment[k,3])) | (as.character(sv[,1])==as.character(compartment[k,1]) & as.numeric(sv[,4])>=as.numeric(compartment[k,2]) & as.numeric(sv[,4])<=as.numeric(compartment[k,3])) | (as.character(sv[,1])==as.character(compartment[k,1]) & as.numeric(sv[,3])<=as.numeric(compartment[k,2]) & as.numeric(sv[,4])>=as.numeric(compartment[k,3])) ),])!=0){
compartment[k,7]=1
}
else{
compartment[k,7]=0
}
}
colnames(compartment)[7]="sv"

ConservativeSV=compartment[which(compartment$class=="conservative" & compartment$sv==1),]
ConservativeNSV=compartment[which(compartment$class=="conservative" & compartment$sv==0),]
VariableSV=compartment[which(compartment$class=="variable" & compartment$sv==1),]
VariableNSV=compartment[which(compartment$class=="variable" & compartment$sv==0),]
pvalue=fisher.test(matrix(c(nrow(ConservativeSV),nrow(ConservativeNSV),nrow(VariableSV),nrow(VariableNSV)),nrow=2))$p.value
line=data.frame(sample=sample,svname=svname,ConservativeSV=nrow(ConservativeSV),ConservativeNSV=nrow(ConservativeNSV),VariableSV=nrow(VariableSV),VariableNSV=nrow(VariableNSV),pvalue=pvalue)
output=rbind(output,line)
}
}
write.csv(output,"structural_variation_conservative_variable_ab_compartment.csv",row.names=F,quote=F)
