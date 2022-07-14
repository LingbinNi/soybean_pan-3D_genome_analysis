#!/bin/bash

for sample in $(find -name "TZX*" -maxdepth 1)
do
samplename=$(basename $sample)
mkdir $samplename
done

for sample in $(find  -name "TZX*" -maxdepth 1)
do
samplename=$(basename $sample)
cp -r $sample/reads/ ./$samplename/
done

for sample in $(find . -name "TZX*" -maxdepth 1)
do
cat>$sample/config-ReferenceMapping.txt<<EOF
# Please change the variable settings below if necessary

#########################################################################
## Paths and Settings  - Do not edit !
#########################################################################

TMP_DIR = tmp
LOGS_DIR = logs
BOWTIE2_OUTPUT_DIR = bowtie_results
MAPC_OUTPUT = hic_results
RAW_DIR = rawdata

#######################################################################
## SYSTEM AND SCHEDULER - Start Editing Here !!
#######################################################################
N_CPU = 4
LOGFILE = hicpro.log

JOB_NAME = 
JOB_MEM = 
JOB_WALLTIME = 
JOB_QUEUE = 
JOB_MAIL = 

#########################################################################
## Data
#########################################################################

PAIR1_EXT = _R1
PAIR2_EXT = _R2

#######################################################################
## Alignment options
#######################################################################

FORMAT = phred33
MIN_MAPQ = 0

BOWTIE2_IDX_PATH = /database/index
BOWTIE2_GLOBAL_OPTIONS = --very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder
BOWTIE2_LOCAL_OPTIONS =  --very-sensitive -L 20 --score-min L,-0.6,-0.2 --end-to-end --reorder

#######################################################################
## Annotation files
#######################################################################

REFERENCE_GENOME = GmaxZH13_v2
GENOME_SIZE = /database/annotation/chrom_gmZH13.sizes
CAPTURE_TARGET =

#######################################################################
## Allele specific analysis
#######################################################################

ALLELE_SPECIFIC_SNP = 

#######################################################################
## Digestion Hi-C
#######################################################################

GENOME_FRAGMENT = /database/annotation/GmaxZH13_v2_mboi_dpnii.bed
LIGATION_SITE = GATCGATC
MIN_FRAG_SIZE = 
MAX_FRAG_SIZE =
MIN_INSERT_SIZE =
MAX_INSERT_SIZE =

#######################################################################
## Hi-C processing
#######################################################################

MIN_CIS_DIST =
GET_ALL_INTERACTION_CLASSES = 1
GET_PROCESS_SAM = 0
RM_SINGLETON = 1
RM_MULTI = 1
RM_DUP = 1

#######################################################################
## Contact Maps
#######################################################################

BIN_SIZE = 5000 10000 25000 40000 100000 500000 1000000
MATRIX_FORMAT = upper

#######################################################################
## Normalization
#######################################################################
MAX_ITER = 100
FILTER_LOW_COUNT_PERC = 0.02
FILTER_HIGH_COUNT_PERC = 0
EPS = 0.1
EOF
done
