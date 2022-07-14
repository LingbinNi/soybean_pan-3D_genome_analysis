#!/bin/bash

#mapping init command
for sample in $(find . -name "TZX*" -maxdepth 1)
do
/software/HiC-Pro/HiC-Pro_2.9.0/bin/HiC-Pro -i $sample/reads -o $sample/output -c $sample/config-ReferenceMapping.txt -p
done

#mapping step 1
for file in $(find . -name "TZX*" -maxdepth 1)
do
filename=$(basename $file)
echo $filename
sed -i 2','5'd' ./$filename/output/HiCPro_step1_.sh
sed -i 's/#BSUB -q /#BSUB -q lowl/g' ./$filename/output/HiCPro_step1_.sh
cd ./$filename/output/
bsub < HiCPro_step1_.sh
cd ../..
done

#mapping step 2
for file in $(find . -name "TZX*" -maxdepth 1)
do
filename=$(basename $file)
echo $filename
cd ./$filename/output/
sed -i 2','5'd' HiCPro_step2_.sh
sed -i 's/#BSUB -q /#BSUB -q lowl/g' HiCPro_step2_.sh
sed -i 's/#BSUB -n 6/#BSUB -n 2/g' HiCPro_step2_.sh
bsub < HiCPro_step2_.sh
cd ../..
done
