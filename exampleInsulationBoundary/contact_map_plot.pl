#!/usr/bin/perl -w 

die "Usage: $0 <chromosome> <start> <end> in ZH13 genome\n" unless(@ARGV==3);
my ($chr,$start,$end) = @ARGV;

open (INI,">ReferenceMapping.track")|| die "can not open the file ReferenceMapping.track\n";
print INI "[hic]
file = /01.MatrixFormat/04.H5/ReferenceMapping/KR/25000/TZX544/TZX544_ReferenceMapping_Merge_25000_KR.h5
title = TZX544
depth = 1000000
transform = log1p
file_type = hic_matrix
show_masked_bins = false
colormap = RdYlGn_r

[tads]
file = /01.InsulationBoundaryList/02.NoneInsulationBoundary/TZX544-NoneInsulationBoundary
file_type = domains
overlay_previous = share-y
border_color = black
color = none

[spacer]
height = 0.5

";

my @samplelist = ("TZX250","TZX248","TZX230","TZX358","TZX2019","TZX1055","TZX1058","TZX062","TZX693","TZX1029","TZX1024","TZX1246","TZX2379","TZX2441","TZX1145","TZX1271","TZX1230","TZX1744","TZX1297","TZX1720","TZX1695","TZX210","TZX1601","TZX1399","TZX1436","TZX2139");
foreach $sample (@samplelist){
print INI "[hic]
file = /01.MatrixFormat/04.H5/ReferenceMapping/KR/25000/$sample/$sample\_ReferenceMapping_Merge_25000_KR.h5
title = $sample
depth = 1000000
transform = log1p
file_type = hic_matrix
show_masked_bins = false
colormap = RdYlGn_r

[spacer]
height = 0.5

";
}
close(INI);

system("hicPlotTADs --tracks ReferenceMapping.track --region $chr:$start-$end -o ReferenceMapping.pdf --width 30 --height 100");
