#!/bin/bash
#title          :2_Database.sh
#description    :Searching for gene homologues
#author         :Julius Nweze
#date           :20230811
#version        :V.1
#usage          :./2_Database.sh
#===========================================================================================================

# Set the working and the Database directories.
    WORKDIR=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Detoxification/Lignin/Epi/MG
    DATABASE=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Vitamins_MG_MT/Epi/MG/Database
    OUTPUT1="$WORKDIR/Genes"

# Create a folder named Database
    mkdir -p "$DATABASE"

# Concatenate all the genomes into a single file
    cat "$WORKDIR/Genomes"/*.fasta > "$DATABASE/all.genomes.fasta"

# Run Prodigal on the concatenated genomes to predict open reading frames
    for FILE in "$DATABASE"/*.fasta; do
    base=$(basename "$FILE" .fasta) # Extract filename without extension
    prodigal -i "$FILE" -a "$DATABASE/${base}.faa" -o "$DATABASE/${base}.gff"
    done

# Index the annotation output to form a database
    esl-sfetch --index "$DATABASE/all.genomes.faa"

