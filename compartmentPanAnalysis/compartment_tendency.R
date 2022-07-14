#!/usr/bin/env Rscript

data=read.csv("compartment_pan_analysis.csv",header=T)
data=data[,c(4:30)]

dataplot=data.frame(samplenumber=numeric(),type=character(),percentage=numeric())

#2-25
for (i in c(2:25)){
for (j in c(1:100)){
colnum=sample(c(1:27),size=i)
datasub=data[,colnum]
datasub$Acompartment=rowSums(datasub[,c(1:i)]<0)
datasub$Bcompartment=rowSums(datasub[,c(1:i)]>0)
conserve=nrow(datasub[which(datasub$Acompartment==i | datasub$Bcompartment==i | (datasub$Acompartment==0 & datasub$Bcompartment==0)),])
conservepercentage=round(conserve/nrow(datasub)*100,2)
datatemp=data.frame(samplenumber=i,type="conserve",percentage=conservepercentage)
dataplot=rbind(dataplot,datatemp)
variablepercentage=100-conservepercentage
datatemp=data.frame(samplenumber=i,type="variable",percentage=variablepercentage)
dataplot=rbind(dataplot,datatemp)
}
}

#26
i=26
for (j in c(1:27)){
colnum=c(1:27)[-j]
datasub=data[,colnum]
datasub$Acompartment=rowSums(datasub[,c(1:i)]<0)
datasub$Bcompartment=rowSums(datasub[,c(1:i)]>0)
conserve=nrow(datasub[which(datasub$Acompartment==i | datasub$Bcompartment==i | (datasub$Acompartment==0 & datasub$Bcompartment==0)),])
conservepercentage=round(conserve/nrow(datasub)*100,2)
datatemp=data.frame(samplenumber=i,type="conserve",percentage=conservepercentage)
dataplot=rbind(dataplot,datatemp)
variablepercentage=100-conservepercentage
datatemp=data.frame(samplenumber=i,type="variable",percentage=variablepercentage)
dataplot=rbind(dataplot,datatemp)
}

#27
i=27
datasub=data
datasub$Acompartment=rowSums(datasub[,c(1:i)]<0)
datasub$Bcompartment=rowSums(datasub[,c(1:i)]>0)
conserve=nrow(datasub[which(datasub$Acompartment==i | datasub$Bcompartment==i | (datasub$Acompartment==0 & datasub$Bcompartment==0)),])
conservepercentage=round(conserve/nrow(datasub)*100,2)
datatemp=data.frame(samplenumber=i,type="conserve",percentage=conservepercentage)
dataplot=rbind(dataplot,datatemp)
variablepercentage=100-conservepercentage
datatemp=data.frame(samplenumber=i,type="variable",percentage=variablepercentage)
dataplot=rbind(dataplot,datatemp)

write.csv(dataplot,file="compartment_tendency.csv",row.names=F,quote=F)
