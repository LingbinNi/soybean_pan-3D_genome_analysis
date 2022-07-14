#!/usr/bin/perl -w 

#file dirtionary
$dirname="/02.Pan3Dgenome/03.Statistics";
opendir(DIR,$dirname)|| die "Error in opening dir $dirname\n";
@filelist = grep {/statistics$/} readdir(DIR);
closedir(DIR);
#put same tad into hash
my %hash=();
foreach $filename (@filelist){
open (STAT,"$dirname/$filename")|| die "can not open the file $filename\n";
while(<STAT>){
    chomp;
    my @line = split("\t");
    if (defined($line[1])){
    push @{$hash{$line[0]}},$line[0];
    my @info = split(";",$line[1]);
    foreach $infoitem (@info){
    my @array = split(":",$infoitem);
    push @{$hash{$line[0]}},$array[1];
    }
    }
}
close(STAT);
}
#file manage
my %hashmerge=();
my $premerge = 1;
my $aftermerge = 0;
###loop
until ($premerge == $aftermerge){
###merge
%hashmerge=();
$premerge = 0;
foreach my $key (sort keys %hash){
$premerge = $premerge + 1;
my @value = @{$hash{$key}};
@{$hashmerge{$key}} = @value;
    foreach my $key2 (sort keys %hash){
    my @value2 = @{$hash{$key2}};
    my %hash_value = map{$_=>1} @value;
    my %hash_value2 = map{$_=>1} @value2;
    my @common = grep {$hash_value{$_}} @value2;
    my $commonnum = @common;
    if ($commonnum > 0){
    push @{$hashmerge{$key}},@value2;
    }
    }
}
###remove duplication
my @total=();
foreach my $key (sort keys %hashmerge){
    my @value = @{$hashmerge{$key}};
    my %temp=();
    my @uniqvalue=grep{++$temp{$_}<2}@value;
    my @sortuniqvalue = sort @uniqvalue;
    my $sortuniqvaluearray = join(":",@sortuniqvalue);
    push @total,$sortuniqvaluearray;
}
my %temp=();
my @uniqtotal=grep{++$temp{$_}<2}@total;
###hash
%hash=();
$aftermerge = 0;
foreach $uniqtotalline (@uniqtotal){
$aftermerge = $aftermerge + 1;
my @array = split(":",$uniqtotalline);
@{$hash{$uniqtotalline}} = @array;
}
}
#output
open (OUT,">BoundaryCluster.out")|| die "can not open the file BoundaryCluster.out\n";
foreach my $key (sort keys %hash){
    my @value = @{$hash{$key}};
    my $outline = join(":",@value);
    print OUT "$outline\n"
}
close(OUT);
