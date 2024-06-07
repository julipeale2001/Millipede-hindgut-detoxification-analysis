#!/bin/bash
#title          :coverm.sh
#description    :For sequence annotation 
#author         :Julius Nweze
#date           :20230527
#version        :1.0
#usage          :./4_CoverM.sh
#==============================================================================================

# Set the working and the Database directories.
WORKDIR=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Detoxification/Lignin/Epi/MG
OUTPUT1="$WORKDIR/CoverM/Trimmed"
OUTPUT2="$WORKDIR/CoverM/New"
OUTPUT3="$WORKDIR/CoverM/Rename"
OUTPUT4="$WORKDIR/CoverM/Coverage"

# Trim fasta headers
mkdir -p "$OUTPUT1"
for i in *.fasta; do
    awk '/^>/ {sub(/\/.*$/, "", $0)} 1' "$i" > "$OUTPUT1/${i%.fasta}_trimmed.fa"
done

### Append file names to contig gene names
mkdir -p "$OUTPUT2"
for i in "$OUTPUT1"/*_trimmed.fa; do
    filename=$(basename "$i" _trimmed.fa)
    awk -v fname="$filename" '/>/{sub(">", "&" fname "_"); sub(/_trimmed\.fa/, "");}1' "$i" > "$OUTPUT2/$filename.fasta"
done
    
# Cat and merge the genes
cat "$OUTPUT2"/*.fasta > "$OUTPUT3/Gene.merged.fasta"

# Remove duplicate contigs
seqkit --quiet --id-regexp '(^\w+-[0-9])' rmdup "$OUTPUT3/Gene.merged.fasta" > "$OUTPUT3/Gene.merged.fastai"

# Run CoverM for Epibolus metagenomes
mkdir -p "$OUTPUT4"
for i in "$OUTPUT3"/Gene.merged.fastai; do
    coverm contig --coupled ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE2/DE2_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE2/DE2_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE3/DE3_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE3/DE3_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE5/DE5_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE5/DE5_L1_2.fq.gz -r "$i" -o "$OUTPUT4/${i}.output.tsv" -m tpm --min-read-percent-identity 0.90 -p bwa-mem --threads 10 
done

