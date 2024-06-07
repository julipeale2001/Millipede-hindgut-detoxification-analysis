#!/bin/bash
#title          :blastp.sh
#description    :For sequence annotation 
#author         :Julius Nweze
#date           :20230527
#version        :1.0
#usage          :./5_blastp.sh
#==============================================================================================

# Set the working directories.
WORKDIR=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Detoxification/Lignin/Epi/MG
OUTPUT1="$WORKDIR/Genes/Trimmed"
OUTPUT2="$WORKDIR/Genes/New"
OUTPUT3="$WORKDIR/Genes/Rename"
OUTPUT4="$WORKDIR/Genes/Confirm"
Database=~/proj/Resources/BLAST/NCBI  # Adjust the path to your database

# Trim fasta headers
mkdir -p "$OUTPUT1"
for i in Genes/*.fa; do
    awk '/^>/ {sub(/\/.*$/, "", $0)} 1' "$i" > "$OUTPUT1/${i%.fa}_trimmed.fa"
done

### Append file names to contig gene names
mkdir -p "$OUTPUT2"
for i in "$OUTPUT1"/*_trimmed.fa; do
    filename=$(basename "$i" _trimmed.fa)
    awk -v fname="$filename" '/>/{sub(">", "&" fname "_"); sub(/_trimmed\.fa/, "");}1' "$i" > "$OUTPUT2/$filename.fasta"
done

# Cat and merge the genes
cat "$OUTPUT2"/*.fasta > "$OUTPUT3/Genes.fasta"

# Remove duplicate contigs
seqkit --quiet --id-regexp '(^\w+-[0-9])' rmdup "$OUTPUT3/Genes.fasta" > "$OUTPUT3/Genes.merged.fasta"

# Update the database
update_blastdb.pl --passive --decompress "$Database/refseq_protein"  #nr,refseq_protein,swissprot,taxdb 

# Run local blastp
~/ncbi-blast/bin/blastp -query "$OUTPUT3/Genes.merged.fasta" -db "$Database/refseq_protein"  -max_target_seqs 5  -out "$OUTPUT4/Genes.merged.output.txt" -num_threads 20 -outfmt '7 qseqid sblastname sscinames sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore'

