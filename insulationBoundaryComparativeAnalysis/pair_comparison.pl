#!/usr/bin/perl -w 

$dirname="/01.InsulationBoundary";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/^TZX/} readdir(DIR);
closedir(DIR);

open (REF,"/01.InsulationBoundary/TZX544-InsulationBoundary")|| die "can not open the file TZX544-InsulationBoundary\n";
chomp(my @ref = <REF>);
close(REF);

my $flanklength = 25000;
foreach $file (@filelist){
my $sample = $file;
$sample =~ s/-InsulationBoundary//g;
#array
open (QRY,"$dirname/$file")|| die "can not open the file $file\n";
chomp(my @qry = <QRY>);
close(QRY);
#loop
open (OUT,">TZX544-$sample-InsulationBoundary.PairComparison")|| die "can not open the file TZX544-$sample-InsulationBoundary.PairComparison\n";
foreach (@qry){
    chomp;
    my @qryline = split("\t");
    my $qrychr = $qryline[0];
    my $qrystart = $qryline[1];
    my $qryend = $qryline[2];
    my $qrysign = $qryline[3];
    my $qrystartcoords = $qrystart - $flanklength;
    my $qryendcoords = $qryend + $flanklength;
    my @info = ();
    foreach (@ref){
    chomp;
    my @refline = split("\t");
    my $refchr = $refline[0];
    my $refstart = $refline[1];
    my $refend = $refline[2];
    my $refstartcoords = $refstart - $flanklength;
    my $refendcoords = $refend + $flanklength;
    if (($refchr eq $qrychr && $refendcoords >= $qrystartcoords && $refendcoords <= $qryendcoords) || ($refchr eq $qrychr && $refstartcoords >= $qrystartcoords && $refstartcoords <= $qryendcoords) || ($refchr eq $qrychr && $refstartcoords <= $qrystartcoords && $refendcoords >= $qryendcoords)){
    my $message = $refchr.":".$refstart.":".$refend;
    push(@info,$message);
    }
    }
    my $infomerge = join(";",@info);
    print OUT "$qrychr\t$qrystart\t$qryend\t$qrysign\t$infomerge\n";
}
close(OUT);
}
