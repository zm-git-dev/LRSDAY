#!/bin/bash
set -e -o pipefail

#######################################
# load environment variables for LRSDAY
source ./../../env.sh

#######################################
# set project-specific variables
sra_id="SRR4074258" # the SRA Run ID for the reads that you want to retrieve, e.g. "SRR4074258 for S. cerevisiae strain SK1 generated by Yue et al. (2017) Nature Genetics"

#######################################
# process the pipeline
echo "retrieve reads by the SRR_id: $sra_id ..."
$sra_dir/fastq-dump --defline-seq '@$sn[_$rn]/$ri' --defline-qual '+$sn[_$rn]/$ri' \
      --gzip --split-files -skip-technical --dumpbase --read-filter pass --clip $sra_id

# if the fastq-dump doesn't work due to connection problems, please run the following two wget commands to directly download the reads.
# wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR407/008/SRR4074258/SRR4074258_1.fastq.gz 
# ln -s SRR4074258_1.fastq.gz SRR4074258_pass_1.fastq.gz
#  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR407/008/SRR4074258/SRR4074258_2.fastq.gz
# ln -s SRR4074258_2.fastq.gz SRR4074258_pass_2.fastq.gz

############################
# checking bash exit status
if [[ $? -eq 0 ]]
then
    echo ""
    echo "LRSDAY message: This bash script has been successfully processed! :)"
    echo ""
    echo ""
    exit 0
fi
############################
