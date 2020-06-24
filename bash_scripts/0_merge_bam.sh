#!/bin/bash
#
#$ -q regular
#$ -l h=rock*
#$ -pe cores 10
#$ -t 1-18
#$ -cwd
#$ -j y
#$ -S /bin/bash 
#$ -N merge_ccs
#$ -o OUT_$JOB_NAME.$JOB_ID
#$ -e ERR_$JOB_NAME.$JOB_ID
#$ -m bea

hostname
echo "${SGE_TASK_ID} start `date`"

## Export libraries into bin
export LD_LIBRARY_PATH=/apps/biotools/smrtlink-5.0/lib:$LD_LIBRARY_PATH
export PATH=/apps/biotools/smrtlink-5.1/smrtcmds/bin/:$PATH
module load devel/GCC-7.1.0

## Load directories & set up parameters
ccsBam=`awk -v row=${SGE_TASK_ID} "NR==row" path2ccsBam.txt` # path2ccsBam is a text file with the complete path to PacBio subreads.bam
file=`cat ${ccsBam}`
outPath=`awk -v row=${SGE_TASK_ID} "NR==row" path2results.txt` # path2results is a text file with the complete path where results are supposed to be saved
outName=`echo $ccsBam | cut -f8 -d'/'`

## finally start the actual work
cd ${outPath}

/apps/biotools/smrtlink-5.1/smrtcmds/bin/dataset create --force --type ConsensusReadSet ${outPath}/${outName}.ConsensusReadSet.xml ${file}

date

