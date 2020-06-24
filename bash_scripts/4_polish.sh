#!/bin/bash
#
#$ -q regular
#$ -l h=rock*
#$ -pe cores 12
#$ -t 1-11
#$ -cwd
#$ -j y
#$ -S /bin/bash 
#$ -N POLISH_Step
#$ -o OUT_$JOB_NAME.$JOB_ID
#$ -e ERR_$JOB_NAME.$JOB_ID

hostname
echo "${SGE_TASK_ID} start `date`"

## Export libraries into bin
export LD_LIBRARY_PATH=/apps/biotools/smrtlink-5.0/lib:$LD_LIBRARY_PATH
export PATH=$PATH:/apps/biotools/anaconda/3.6/bin
module load devel/GCC-7.1.0

## Load directories & set up parameters
unpolishedBam=`awk -v row=${SGE_TASK_ID} "NR==row" path2unpolishedBam.txt`
subreadsBam=`awk -v row=${SGE_TASK_ID} "NR==row" path2subreadXML.txt`
outPath=`awk -v row=${SGE_TASK_ID} "NR==row" path2results.txt `
outName=`echo $outPath | cut -f8 -d'/'`

## finally start the actual work
cd ${outPath}
isoseq3 polish ${unpolishedBam} ${subreadsBam} ${outName}.polished.bam --verbose

date

