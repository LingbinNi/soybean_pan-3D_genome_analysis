#!/usr/bin/perl -w 

###step1: genome replace
$dirname = "/DataBase/genome";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/fasta$/} readdir(DIR);
closedir(DIR);

#read fasta, and the output file is renamed sample.replace.fasta
foreach $filename (@filelist){
my $sample = (split(/\./,,$filename))[0];
print "$sample\n";
open ($genome,"$dirname/$filename")|| die "can not open the file $filename\n";
open ($output,">$sample.replace.fasta")|| die "can not open the file $sample.replace.fasta\n";

my @repeat=();
open ($repeatfile,"/DataBase/repeatmasker/merge/$sample.repeatmasker")|| die "can not open the file $sample.repeatmasker\n";
@repeat = <$repeatfile>;
close($repeatfile);

while(<$genome>){
chomp;
#get chromosome name and seqs
if(m/^>Chr/){
my $title = $_;#chromosome name
print $output "$title\n";
$titlename=$title;
$titlename =~ s/>//;
chomp(my $sequence = <$genome>);#chromosome seqs
#repeat replace
foreach $repeatline (@repeat){
chomp($repeatline);
my @line = split(/\t/,$repeatline);
my $chr=$line[0];
my $start=$line[1];
my $end=$line[2];
if ($titlename eq $chr){
$length=$end-$start+1;
substr($sequence,$start-1,$length)="R" x $length;
}
}
#output one processed chromosome
print $output "$sequence\n";
}
}

close($genome);
close($output);
}

###step2: calculation
$dirname = "/1.compartment_bed";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@compartmentfilelist = grep {/^TZX/} readdir(DIR);
closedir(DIR);

foreach $compartmentfilename (@compartmentfilelist){
my $sample = (split(/[_|.]/,$compartmentfilename))[0];

open ($genome,"/01.genome_replace/$sample.replace.fasta")|| die "can not open the file $sample.replace.fasta\n";
open ($output,">$sample\_repeat_percentage")|| die "can not open the file $sample\_repeat_percentage\n";

while(<$genome>){
chomp;
#extract matched chromosome name and seqs
if(m/^>Chr/){
my $title = $_;
$titlename=$title;
$titlename =~ s/>//;
chomp(my $sequence = <$genome>);

my $repeatcount=$sequence=~tr/R//;#repeat length
my $atgccount=$sequence =~ tr/ATGCatgc/ATGCatgc/;#non-repeat length
my $ratio=sprintf("%.2f",$repeatcount * 100 / ($repeatcount+$atgccount));#repeat percentage
print $output "$sample\t$titlename\t$ratio\n";#output as one compartment bin
}
}

close($genome);
close($output);
}
