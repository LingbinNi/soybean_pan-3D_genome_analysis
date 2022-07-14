#!/usr/bin/perl -w 

$dirname = "/01.EnrichmentAnalysis/00.DataBase/01.PANNZER2";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@samplelist = grep {/^TZX/} readdir(DIR);
closedir(DIR);

open (OUT,">TERM2NAME.All.out")|| die "can not open the file TERM2NAME.All.out\n";
open (OUT1,">TERM2NAME.CC.out")|| die "can not open the file TERM2NAME.CC.out\n";
open (OUT2,">TERM2NAME.MF.out")|| die "can not open the file TERM2NAME.MF.out\n";
open (OUT3,">TERM2NAME.BP.out")|| die "can not open the file TERM2NAME.BP.out\n";

foreach $sample (@samplelist){
open (FH,"$dirname/$sample/GO.out")|| die "can not open the file /$sample/GO.out\n";
while(<FH>){
chomp;
my @array = split("\t");
#All
if($array[0] =~ /\.m1$/){
print OUT "$array[2]\t$array[3]\n";
}
#CC
if($array[0] =~ /\.m1$/ && $array[1] eq "CC"){
print OUT1 "$array[2]\t$array[3]\n";
}
#MF
if($array[0] =~ /\.m1$/ && $array[1] eq "MF"){
print OUT2 "$array[2]\t$array[3]\n";
}
#BP
if($array[0] =~ /\.m1$/ && $array[1] eq "BP"){
print OUT3 "$array[2]\t$array[3]\n";
}
}
close (FH);
}

close (OUT);
close (OUT1);
close (OUT2);
close (OUT3);
