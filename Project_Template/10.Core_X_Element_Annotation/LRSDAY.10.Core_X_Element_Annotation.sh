#!/bin/bash
set -e -o pipefail
#######################################
# load environment variables for LRSDAY
source ./../../env.sh

#######################################
# set project-specific variables
genome="./../06.Supervised_Final_Assembly/SK1.final.fa" # path of the input genome assembly
prefix="SK1" # file name prefix for the output files
debug="no" # use "yes" if prefer to keep intermediate files, otherwise use "no".

#######################################
# process the pipeline
feature_type="X_element"
length_cutoff_for_completeness=300
$hmmer_dir/nhmmer -E 1 --tblout $prefix.$feature_type.nhmmer.out $LRSDAY_HOME/data/S288C.$feature_type.hmm $genome
perl $LRSDAY_HOME/scripts/nhmer2seq.pl  -r $genome -i $prefix.$feature_type.nhmmer.out -e 0.0001 -p $prefix -ft $feature_type -l $length_cutoff_for_completeness
perl $LRSDAY_HOME/scripts/tidy_maker_gff3.pl -i $prefix.$feature_type.raw.gff3 -r $genome -o $prefix.$feature_type.gff3 -t $prefix
perl $LRSDAY_HOME/scripts/gff2seq_simple.pl -r $genome -g $prefix.$feature_type.gff3 -o $prefix.$feature_type.fa 
$muscle_dir/muscle -in $prefix.$feature_type.fa -out $prefix.$feature_type.aln.fa

# clean up intermediate files
if [[ $debug == "no" ]]
then
    rm $prefix.$feature_type.raw.gff3
    rm $prefix.$feature_type.raw.fa
fi

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
