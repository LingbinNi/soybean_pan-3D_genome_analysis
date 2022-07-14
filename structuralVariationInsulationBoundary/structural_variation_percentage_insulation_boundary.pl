#!/usr/bin/perl -w 

die "Usage: $0 <svname> <sample> <sv>\n" unless(@ARGV==3);
my ($svname,$sample,$sv) = @ARGV;

#window
open ($windowfile,"/1.bedtools_gc/$sample\_SelfMapping_Merge_25000_abs.gc")|| die "can not open the file $sample\_SelfMapping_Merge_25000_abs.gc\n";
@window = <$windowfile>;
close($windowfile);
#genome
open ($genome,"/00.GenomeReplace/$svname/$sample.replace.fasta")|| die "can not open the file $sample.replace.fasta\n";
open ($output,">$sample.$sv.Percentage")|| die "can not open the file $sample.$sv.Percentage\n";
#calculation
while(<$genome>){
chomp;
#extract chr and sequence
if(m/^>Chr/){
my $title = $_;
$titlename=$title;
$titlename =~ s/>//;
chomp(my $sequence = <$genome>);
#extract window coords
foreach $windowline (@window){
chomp($windowline);
my @line = split(/\t/,$windowline);
my $chr=$line[0];
my $start=$line[1];
my $end=$line[2];
#extract window sequence
if ($titlename eq $chr){
$length=$end-$start+1;
my $subsequence=substr($sequence,$start-1,$length);
my $repeatcount=$subsequence=~tr/R//;
my $atgccount=$subsequence =~ tr/ATGCatgc/ATGCatgc/;
if ($repeatcount==0 && $atgccount==0){
print $output "$chr\t$start\t$end\t0\n";
}
else{
my $ratio=sprintf("%.2f",$repeatcount * 100 / ($repeatcount+$atgccount));
print $output "$chr\t$start\t$end\t$ratio\n";
}
}
}#end window scan
}#end genome scan
}
close($genome);
close($output);
