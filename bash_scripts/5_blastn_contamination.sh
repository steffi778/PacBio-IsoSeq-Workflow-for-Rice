#!/bin/bash
#
#$ -q regular
#$ -l h=rock0*
#$ -pe cores 6
#$ -t 1-424
#$ -cwd
#$ -j y
#$ -S /bin/bash 
#$ -N BLASTN
#$ -o OUT_$JOB_NAME.$JOB_ID
#$ -e ERR_$JOB_NAME.$JOB_ID
##$ -m bea
##$ -M Schaarschmidt@mpimp-golm.mpg.de

hostname
echo "${SGE_TASK_ID} start `date`"

## Load modules
module load biotools/ncbi-blast-2.3.0+
export BLASTDB='/scratch/smrtlink/pipeline/refseq_resources/20170306/nt'
#gunzip -cd taxdb.tar.gz | (cd $BLASTDB; tar xvf - )


## Load directories & set up parameters
fasta=`awk -v row=${SGE_TASK_ID} "NR==row" path2fasta.txt`
outName=`basename ${fasta} .fa`

## finally start the actual work
blastn -query ${fasta} -db nt -num_threads 6 -max_target_seqs 1 -outfmt "6 qseqid sseqid pident qlen length mismatch gapope evalue bitscore staxids sscinames" -out res_blastn/${outName}.blastn.out -evalue 1e-10 -task 'blastn'

date
