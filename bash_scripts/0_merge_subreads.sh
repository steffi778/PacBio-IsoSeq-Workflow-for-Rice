#!/bin/bash
#
#$ -q regular
#$ -l h=rock*
#$ -pe cores 10
#$ -t 1-18
#$ -cwd
#$ -j y
#$ -S /bin/bash 
#$ -N merge_subreads
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
subreadBam=`awk -v row=${SGE_TASK_ID} "NR==row" path2subreads.txt`
file=`cat ${subreadBam}`
outPath=`awk -v row=${SGE_TASK_ID} "NR==row" path2results.txt`
outName=`echo $outPath | cut -f8 -d'/'`

## finally start the actual work
cd ${outPath}

/apps/biotools/smrtlink-5.1/smrtcmds/bin/dataset create --force --type SubreadSet ${outPath}/${outName}.SubreadSet.xml ${file}

date
