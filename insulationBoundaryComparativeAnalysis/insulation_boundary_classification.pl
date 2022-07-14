#!/usr/bin/perl - w

$dirname="../02.PairComparison";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/^TZX/} readdir(DIR);
closedir(DIR);

foreach $file (@filelist){
#sample
my $sample = $file;
$sample =~ s/-InsulationBoundary.PairComparison//;
$sample =~ s/TZX544-//;
#comparison
my @qrycommon = ();
my @refcommon = ();
my %qry = ();
open (COMPARE,"$dirname/$file")|| die "can not open the file $file\n";
while (<COMPARE>){
    chomp;
    my @array = split("\t");
    if ($array[4]){
    push (@qrycommon,$array[3]);
    $qry{$array[3]}=1;
    push (@refcommon,$array[4]);
    }
}
close(COMPARE);
#output
###query common
open (QRYCOMMON,">TZX544-$sample-InsulationBoundary.QueryCommon")|| die "can not open the file TZX544-$sample-InsulationBoundary.QueryCommon\n";
foreach (@qrycommon){
    my @array = split(/:|-|\|/);
    print QRYCOMMON "$array[2]\t$array[3]\t$array[4]\n";
}
close(QRYCOMMON);
###reference common
my @refcommonmerge = ();
open (REFCOMMON,">TZX544-$sample-InsulationBoundary.ReferenceCommon")|| die "can not open the file TZX544-$sample-InsulationBoundary.ReferenceCommon\n";
foreach (@refcommon){
    my @array = split(/;/);
    foreach (@array){
    push (@refcommonmerge,$_);
    }
}
my %ref = ();
foreach (@refcommonmerge){
    $ref{$_}=1;
}
foreach (keys %ref){
    my @array = split(":");
    print REFCOMMON "$array[0]\t$array[1]\t$array[2]\n";
}
close(REFCOMMON);
###query specific
open (QRYSPECIFIC,">TZX544-$sample-InsulationBoundary.QuerySpecific")|| die "can not open the file TZX544-$sample-InsulationBoundary.QuerySpecific\n";
open (QRY,"/01.InsulationBoundaryList/01.InsulationBoundary/$sample-InsulationBoundary")|| die "can not open the file $sample-InsulationBoundary\n";
while (<QRY>){
    chomp;
    my @array = split("\t");
    unless ($qry{$array[3]}){
    print QRYSPECIFIC "$array[0]\t$array[1]\t$array[2]\n";
    }
}
close(QRY);
close(QRYSPECIFIC);
###reference specific
open (REFSPECIFIC,">TZX544-$sample-InsulationBoundary.ReferenceSpecific")|| die "can not open the file TZX544-$sample-InsulationBoundary.ReferenceSpecific\n";
open (REF,"/01.InsulationBoundary/TZX544-InsulationBoundary")|| die "can not open the file TZX544-InsulationBoundary\n";
while (<REF>){
    chomp;
    my @array = split("\t");
    my $key = join(":",$array[0],$array[1],$array[2]);
    unless ($ref{$key}){
    print REFSPECIFIC "$array[0]\t$array[1]\t$array[2]\n";
    }
}
close(REF);
close(REFSPECIFIC);
}
