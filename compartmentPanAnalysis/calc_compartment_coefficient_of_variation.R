#!/usr/bin/env Rscript

data=read.csv("compartment_pan_analysis.csv",header=T)

datasub=data[which(data[,31]<0 & data[,32]>0),]
datasub$ccv=log(datasub[,32]/abs(datasub[,31]))
write.csv(datasub,"calc_compartment_coefficient_of_variation.csv",row.names=F,quote=F)
