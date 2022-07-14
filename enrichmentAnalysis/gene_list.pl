#!/usr/bin/perl -w 

$dirname = "/DataBase/03.GeneFiles";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/^TZX-/} readdir(DIR);
closedir(DIR);

my @typelist = ("core","dispensable","private");

foreach $type (@typelist){

my @pan = ();
open (PAN,"/05.Pan3Dgenome/Pan3Dgenome")|| die "can not open the file Pan3Dgenome\n";
while (<PAN>){
chomp;
my @array = split ("\t");
if ($array[6] eq $type){
push (@pan,$_);
}
}
close (PAN);

open (OUT,">GeneList.$type.out")|| die "can not open the file GeneList.$type.out\n";

foreach $file (@filelist){
my $samplenumber = (split(/[-|.]/,$file))[1];
my $sample = join ("","TZX",$samplenumber);
#mRNA and m1
my @rna = ();
open (GFF,"$dirname/$file")|| die "can not open the file $file\n";
while (<GFF>){
chomp;
my @array = split ("\t");
if ($array[2] eq "mRNA" && $array[8] =~ /\.m1/){
push (@rna, $_);
}
}
close (GFF);
#sample pan
my @samplepan = grep {$_ =~ $sample} @pan;
#rna name
foreach $samplepanname (@samplepan){
    my @panline = split ("\t",$samplepanname);
    foreach $rnaname (@rna){
        my @rnaline = split ("\t",$rnaname);
        if ($rnaline[0] eq $panline[1] && $rnaline[3] >= $panline[2] && $rnaline[3] < $panline[3]){
        my $rnaname = (split(/[=|;]/,$rnaline[8]))[1];
        print OUT "$rnaname\n";
        }
    }
}
}

close (OUT);
}
