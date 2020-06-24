#!/bin/bash
#
#$ -q regular
#$ -l h=rock0*
#$ -pe cores 10
#$ -t 1-11
#$ -cwd
#$ -j y
#$ -S /bin/bash 
#$ -N BLASTX
#$ -o OUT_$JOB_NAME.$JOB_ID
#$ -e ERR_$JOB_NAME.$JOB_ID

hostname
echo "${SGE_TASK_ID} start `date`"

## Load modules
module load biotools/ncbi-blast-2.3.0+
export BLASTDB='/scratch/smrtlink/pipeline/refseq_resources/20170306/nr'
#gunzip -cd taxdb.tar.gz | (cd $BLASTDB; tar xvf - )


## Load directories & set up parameters
fasta=`awk -v row=${SGE_TASK_ID} "NR==row" path2blastx.txt`
outName=`basename ${fasta} .fasta`

## finally start the actual work
blastx -query ${fasta} -db nr -num_threads 10 -max_target_seqs 1 -outfmt "6 qseqid sseqid pident qlen length mismatch gapope evalue bitscore staxids sscinames" -out res_blastx/${outName}.blastx.out -evalue 1e-10

date

