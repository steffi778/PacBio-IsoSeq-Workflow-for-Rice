#!/bin/bash
#
#$ -q regular
#$ -l h=rock*
#$ -pe cores 15
#$ -t 1-6
#$ -cwd
#$ -j y
#$ -S /bin/bash 
#$ -N Isoseq3_CCS
#$ -o OUT_$JOB_NAME.$JOB_ID
#$ -e ERR_$JOB_NAME.$JOB_ID

hostname
echo "${SGE_TASK_ID} start `date`"

## Export libraries into bin
export LD_LIBRARY_PATH=/apps/biotools/smrtlink-5.0/lib:$LD_LIBRARY_PATH
export PATH=/apps/biotools/smrtlink-5.1/smrtcmds/bin/:$PATH
module load devel/GCC-7.1.0

## Load directories & set up parameters
subreadsBam=`awk -v row=${SGE_TASK_ID} "NR==row" path2SubreadsBam.txt`
outPath=`awk -v row=${SGE_TASK_ID} "NR==row" path2Results.txt`
outName=`echo $outPath | cut -f8 -d'/'`

## finally start the actual work
cd ${outPath}
ccs $subreadsBam ${outName}.ccs.bam --noPolish --minPasses=1 --numThreads=15

date

