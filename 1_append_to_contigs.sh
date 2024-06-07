#!/bin/bash
#title          :append_to_contigs.sh
#description    :For sequence annotation 
#author         :Julius Nweze
#date           :20230527
#version        :1.0
#usage          :./1_append_to_contigs.sh
#==============================================================================================

# Set the working and the Database directories.
    WORKDIR=~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/CONTIGS/Detoxification/Lignin/Epi/MG
    OUTPUT1="$WORKDIR/Genomes"

# Create a new directory named "New" inside the Genomes directory
    mkdir -p "$OUTPUT1/New"

# Go to the directory where your genomes are and append the file names to contig headers
# Make sure your file name extension is suitable (assuming ".fna" in this case)
    for i in "$OUTPUT1"/*.fna; do 
    fname=$(basename "$i" .fna) # Extract filename without extension
    # Use awk to modify the FASTA headers and save to a new file
    awk -v fname="$fname" '/^>/{print ">" fname substr($0, 2); next} 1' "$i" > "$OUTPUT1/New/${fname}.fasta"
    done


    

    
