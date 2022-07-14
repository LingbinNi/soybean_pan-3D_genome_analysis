#!/usr/bin/perl -w 

$dirname="/02.PairComparison";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/PairComparison$/} readdir(DIR);
closedir(DIR);

open (OUT,">ComparisonStatistics.csv")|| die "can not open the file ComparisonStatistics.csv\n";
print OUT "Sample,QueryUnmatch,QueryMatch,QueryTotal,ReferenceUnmatch,ReferenceMatch,ReferenceTotal\n";
foreach $file (@filelist){
#variable
my $samplematch = 0;
#sample
my $sample = $file;
$sample =~ s/-InsulationBoundary.PairComparison//;
$sample =~ s/TZX544-//;
#file
open (FILE,"$dirname/$file")|| die "can not open the file $file\n";
chomp(my @lines = <FILE>);
close(FILE);
open (REF,"/01.InsulationBoundaryList/01.InsulationBoundary/TZX544-InsulationBoundary")|| die "can not open the file TZX544-InsulationBoundary\n";
chomp(my @reflines = <REF>);
close(REF);
open (SEF,"/01.InsulationBoundaryList/01.InsulationBoundary/$sample-InsulationBoundary")|| die "can not open the file $sample-InsulationBoundary\n";
chomp(my @selflines = <SEF>);
close(SEF);
my $referencetotal = @reflines;
my $sampletotal = @selflines;
#loop
my %hash=();
foreach (@lines){
    chomp;
    my @fileline = split("\t");
    if (defined($fileline[4])){
    $samplematch++;
    my @array=split(";",$fileline[4]);
        foreach $arrayitem (@array){
        $hash{$arrayitem}=1;
        }
    }
}
my @keys = keys %hash;
my $referencematch = @keys;
#calculation
my $sampleunmatch = $sampletotal - $samplematch;
my $referenceunmatch = $referencetotal - $referencematch;
#output
print OUT "$sample,$sampleunmatch,$samplematch,$sampletotal,$referenceunmatch,$referencematch,$referencetotal\n";
}
close(OUT);
