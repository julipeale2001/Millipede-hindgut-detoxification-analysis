#!/bin/bash
#title          :form_hmm.sh
#description    :For sequence annotation 
#author         :Julius Nweze
#date           :20230527
#version        :1.0
#usage          :./3_form_hmm.sh
#==============================================================================================

# Set the working and the Database directories.
    WORKDIR=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Detoxification/Lignin/Epi/MG
    DATABASE=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Vitamins_MG_MT/Epi/MG/Database
    OUTPUT1="$WORKDIR/KO/hmm"
    OUTPUT2="$WORKDIR/STO"
    OUTPUT3="$WORKDIR/Genes"
    OUTPUT4="$WORKDIR/CoverM"

# Create necessary directories if they don't exist
    mkdir -p "$OUTPUT1" "$OUTPUT2" "$OUTPUT3" "$OUTPUT4"

# Build an HMM file for each downloaded protein sequence
    for i in "$WORKDIR/KO"/*.fasta; do
    base=$(basename "$i" .fasta)
    hmmbuild "$OUTPUT1/${base}.hmm" "$i"
    done

# Search for the genes using HMMs and extract them from each genome
    for i in "$OUTPUT1"/*.hmm; do
    base=$(basename "$i" .hmm)
    hmmsearch -E 1e-30 -A "$OUTPUT2/${base}.sto" "$i" "$DATABASE/all.genomes.faa"
    esl-reformat fasta "$OUTPUT2/${base}.sto" > "$OUTPUT3/${base}.fa"
    done

# Convert to nucleotide sequences
    for sample in "$OUTPUT3"/*.fa; do
    base=$(basename "$sample" .fa)
    backtranseq -sequence "$sample" -outfile "$sample.fasta"
    mv "$sample.fasta" "$OUTPUT4"
    done

