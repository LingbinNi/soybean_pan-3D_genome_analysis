#!/bin/bash

#step1: matrix formatting (sparseToDense)
for dir in $(ls -d /01.SparseToDense/TZX*)
do
sample=$(basename $dir)
echo $sample
mkdir $sample
cd $sample

for file in $(ls $dir/TZX*_SelfMapping_Merge_25000_KR_Chr*.match.matrix)
do
filename=$(basename $file .match.matrix)
chr=${filename##*_}
sparseToDense.py \
-b /SelfMapping/raw/25000/$sample/$sample\_$chr\_abs.bed \
-o $sample\_SelfMapping_Merge_25000_KR_$chr\_dense.matrix \
-d \
$file
done

cd ..
done

#step2: title add
for dir in $(ls -d /01.SparseToDense/02.SparseToDense/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample

for file in $(ls $dir/$sample\_SelfMapping_Merge_25000_KR_Chr*_dense.matrix)
do
filename=$(basename $file .matrix)
###1.header
awk -F"\t" -v name="$sample" '{print NR"|"name"|"$1":"$2"-"$3}' $file > temp.rowname
echo `cat temp.rowname`|sed -e 's/ /\t/g'|sed "s/^/\t&/g"> temp.colname
###2.merge
cat $file|cut -f 4- > temp
paste -d"\t" temp.rowname temp > temp1
cat temp.colname temp1 > $filename.insulation.matrix
###3.rm
rm temp*
done

cd ..
done

#step3: insulation score
for dir in $(ls -d /02.ContactMatrix/TZX*)
do
sample=$(basename $dir)
mkdir $sample
cd $sample
for file in $(ls $dir/TZX*_SelfMapping_Merge_25000_KR_Chr*_dense.insulation.matrix)
do
filename=$(basename $file _dense.insulation.matrix)
chr=${filename##*_}
echo $filename
mkdir $chr
cd $chr
bsub -n 1 -q lowl -J $filename -o $filename.o -e $filename.e \
/usr/bin/perl /installation/cworld-dekker-master/scripts/perl/matrix2insulation.pl \
--i $file \
--is 500000 \
--ids 250000
cd ..
done
cd ..
done
