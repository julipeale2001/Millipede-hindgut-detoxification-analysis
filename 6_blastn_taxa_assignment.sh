#!/bin/bash
#title          :blastn.sh
#description    :For sequence annotation 
#author         :Julius Nweze
#date           :20230527
#version        :1.0
#usage          :./6_blastn_taxa_assignment.sh
#==============================================================================================

# Set the working directories.
WORKDIR=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Detoxification/Lignin/Epi/MG
OUTPUT1="$WORKDIR/Genes/Taxonomy"
Database=~/proj/Resources/BLAST/NCBI/nt  # Adjust the path to your database
nodes=~/proj/Resources/BLAST/NCBI/nodes.dmp
names=~/proj/Resources/BLAST/NCBI/names.dmp

# Ensure BLASTDB is set to the location of your taxonomy database
    export BLASTDB="~/proj/Resources/BLAST/NCBI/taxdb"

# Create directories
    mkdir -p "$OUTPUT1"
    mkdir -p "$OUTPUT2"

# Perform blastn
    for i in "$WORKDIR/Genes/Confirm"/*.fasta; do
    ~/ncbi-blast-2.13.0+/bin/blastn -db "$Database" -num_threads 5 -max_target_seqs 1 -outfmt '6 qseqid pident evalue bitscore staxids sgi sacc sskingdoms sblastnames sscinames stitle' -query "$i" -out "$OUTPUT1/$(basename "$i").blastn.txt"
    done

# Extract relevant columns
    for i in "$OUTPUT1"/*.blastn.txt; do
    cut -f1,5 "$i" > "$OUTPUT1/$(basename "$i" .txt)_taxids.txt"
    done

# Perform taxonomy assignment
    for i in "$OUTPUT1"/*_taxids.txt; do
    ~/scripts/tax_trace.pl "$nodes" "$names" "$i" "$OUTPUT2/$(basename "$i" .txt)_export.tsv"
    done

