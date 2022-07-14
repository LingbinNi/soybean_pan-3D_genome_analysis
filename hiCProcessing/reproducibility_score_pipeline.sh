#!/bin/bash

#contact map
for dir in $(ls -d /00.SplitSparse/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample

###RepA
mkdir $sample'A'
cd $sample'A'
for file in $(ls $dir/$sample'A'/TZX*_Chr*.matrix)
do
filename=$(basename $file .matrix)
chr=${filename##*_}
awk -v str=$chr '{print str,$1,str,$2,$3}' OFS="\t" $file >> $sample'A'.res
gzip -c $sample'A'.res > $sample'A'.res.gz
done
cd ..
###RepB
mkdir $sample'B'
cd $sample'B'
for file in $(ls $dir/$sample'B'/TZX*_Chr*.matrix)
do
filename=$(basename $file .matrix)
chr=${filename##*_}
awk -v str=$chr '{print str,$1,str,$2,$3}' OFS="\t" $file >> $sample'B'.res
gzip -c $sample'B'.res > $sample'B'.res.gz
done
cd ..

cd ..
done

#bins
for dir in $(ls -d /00.SplitSparse/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample

###RepA
mkdir $sample'A'
cd $sample'A'
cat $dir/$sample'A'/$sample'A'_Chr*_abs.bed >> Bins.bed
gzip -c Bins.bed > Bins.bed.gz
cd ..
###RepB
mkdir $sample'B'
cd $sample'B'
cat $dir/$sample'B'/$sample'B'_Chr*_abs.bed >> Bins.bed
gzip -c Bins.bed > Bins.bed.gz
cd ..

cd ..
done

#matadata sample
for dir in $(ls -d /01.ContactMap/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample

echo -e $sample'A'"\t"$dir/$sample'A'/$sample'A'.res.gz >> metadata.samples
echo -e $sample'B'"\t"$dir/$sample'B'/$sample'B'.res.gz >> metadata.samples

cd ..
done

#metadata pairs
for dir in $(ls -d /01.ContactMap/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample

echo -e $sample'A'"\t"$sample'B' >> metadata.pairs

cd ..
done

#calculation
dir="/02.ConfigureFiles"

for bindir in $(ls -d /02.Bins/TZX*)
do
sample=$(basename $bindir)
mkdir $sample
cd $sample

genomedisco run_all \
--metadata_samples $dir/01.MetadataSamples/$sample/metadata.samples \
--metadata_pairs $dir/02.MetadataPairs/$sample/metadata.pairs \
--bins $bindir/$sample'A'/Bins.bed.gz \
--outdir ./

cd ..
done

#results extract
for dir in $(ls -d /03.Outdir/TZX*/scores)
do
awk 'NR==2{print $0}' $dir/reproducibility.genomewide.txt >> Summary
done
