#!/usr/bin/perl -w 

die "Usage: $0 <dirname> <filename>\n" unless(@ARGV==2);
my ($dirname,$filename) = @ARGV;

open (COORDS,"$dirname/$filename")|| die "can not open the file $filename\n";
open (OUT,">$filename.statistics")|| die "can not open the file $filename.statistics\n";
#hash define and data structure
my %hash=();
while(<COORDS>){
    chomp;
    my @line = split("\t");
    push @{$hash{$line[11]}{$line[10]}},$_;
}
#hash output
foreach my $ref (sort keys %hash){
my $reflength=75000;
my @info=();
    foreach my $qry (sort keys %{$hash{$ref}}){
    my $qrylength=75000;
#bed generate and merge
    open (TMPREF,">reference.bed.temp")|| die "can not open the file reference.bed.temp\n";
    open (TMPQRY,">query.bed.temp")|| die "can not open the file query.bed.temp\n";
        foreach my $line (@{$hash{$ref}{$qry}}){
        my @array=split("\t",$line);
        print TMPREF "$array[11]\t$array[2]\t$array[3]\n";
        print TMPQRY "$array[10]\t$array[0]\t$array[1]\n";
        }
    close(TMPQRY);
    close(TMPREF);
    system ("sort -k1,1 -k2,2n reference.bed.temp|bedtools merge > reference.sort.bed.temp");
    system ("sort -k1,1 -k2,2n query.bed.temp|bedtools merge > query.sort.bed.temp");
#calculation
####reference
    open (CALREF,"reference.sort.bed.temp")|| die "can not open the file reference.sort.bed.temp\n";
    my $refcount=0;
    while (<CALREF>){
    chomp;
    my @templine=split("\t");
    my $length=$templine[2]-$templine[1];
    $refcount+=$length;
    }
    my $refratio=$refcount/$reflength*100;
    $refratio=sprintf "%.2f",$refratio;
    close(CALREF);
####query
    open (CALQRY,"query.sort.bed.temp")|| die "can not open the file query.sort.bed.temp\n";
    my $qrycount=0;
    while (<CALQRY>){
    chomp;
    my @templine=split("\t");
    my $length=$templine[2]-$templine[1];
    $qrycount+=$length;
    }
    my $qryratio=$qrycount/$qrylength*100;
    $qryratio=sprintf "%.2f",$qryratio;
    close(CALQRY);
#information
    if ($refratio >=40 || $qryratio>=40){
    my $message=$ref.':'.$qry.':'.$refratio.':'.$qryratio;
    push @info,$message;
    }
    system ("rm *.temp");
    }
#output
my $infocombine=join(";",@info);
print OUT "$ref\t$infocombine\n";
}
close(OUT);
close(COORDS);
