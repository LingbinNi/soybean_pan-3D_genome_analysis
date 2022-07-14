#!/usr/bin/perl -w 

#unalignment dirtionary
$dirname = "/02.Pan3Dgenome/01.Fasta";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/bed$/} readdir(DIR);
closedir(DIR);
#unalignment list
my %hash;
my @samplelist=();
foreach $filename (@filelist){
my $samplename = $filename;
$samplename =~ s/-InsulationBoundary.bed//;
push @samplelist,$samplename;
open (BED,"$dirname/$filename")|| die "can not open the file $filename\n";
while(<BED>){
    chomp;
    my @line = split("\t");
    $hash{$line[3]} = 1;
}
close(BED);
}
#alignment list
my %hash2;
my @dispensable=();
my $i = 0;
open (CLU,"/02.Pan3Dgenome/04.Cluster/Cluster.out")|| die "can not open the file Cluster.out\n";
while(<CLU>){
    chomp;
    $i = $i + 1;
    my $clustername = "Alignment-Cluster-".$i."-".$_;
    push @dispensable,$clustername;
    my @line = split(":");
    foreach my $lineitem (@line){
    $hash2{$lineitem} = 1;
    }
}
close(CLU);
#unalignment list
my @private=();
my $j = 0;
foreach my $unalignment (sort keys %hash){
    unless (exists $hash2{$unalignment}){
    $j = $j + 1;
    my $clustername = "Unalignment-Cluster-".$j."-".$unalignment;
    push @private,$clustername;
    }
}
#cluster merge
my @cluster = (@dispensable,@private);
@cluster = sort @cluster;
open (RNAME,">rowname.temp")|| die "can not open the file rowname.temp\n";
print RNAME "cluster\n";
foreach (@cluster){
    print RNAME "$_\n";
}
close (RNAME);
#samplelist
my %removedup;
@samplelist = grep { ++$removedup{$_} < 2 } @samplelist;
#pan-3D genome
foreach $sample (sort @samplelist){
open (QRY,"rowname.temp")|| die "can not open the file rowname.temp\n";
open (OUT,">$sample.temp")|| die "can not open the file $sample.temp\n";
print OUT "$sample\n";
foreach $clustername (@cluster){
    if ($clustername =~ /$sample/){
    print OUT "1\n";
    }
    else{
    print OUT "0\n";
    }
}
close (OUT);
close (QRY);
}
#remove files
system ("paste -d',' rowname.temp TZX*.temp > Pan3Dgenome.csv");
system ("rm *.temp");
