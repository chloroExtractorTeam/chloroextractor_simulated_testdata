#!/bin/bash

# download sequence files
cd /tmp/
wget -O chr1.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_003070.9&extrafeat=976&maxplex=1'
wget -O chr2.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_003071.7&extrafeat=976&maxplex=1'
wget -O chr3.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_003074.8&extrafeat=976&maxplex=1'
wget -O chr4.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_003075.7&extrafeat=976&maxplex=1'
wget -O chr5.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_003076.8&extrafeat=976&maxplex=1'
wget -O mt.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_001284.2&extrafeat=976&maxplex=1'
wget -O pltd.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_000932.1&extrafeat=976&maxplex=1'

# generate a concatinated chloroplast-genome of 200x normal chloroplast
(sed -n '1p' pltd.fasta; for i in $(seq 1 200); do sed '1d' pltd.fasta; done) | sed '/^$/d' > 200pltd.fasta
# generate a concatinated mitochondrion-genome of 50x normal mitochondrion
(sed -n '1p' mt.fasta; for i in $(seq 1 50); do sed '1d' mt.fasta; done) | sed '/^$/d' > 50mt.fasta

# combine all sequences and 
cat 200pltd.fasta chr[12345].fasta 50mt.fasta | sed -n '/^>/{s/^\(>[^[:space:]]*\).*/\1/g;p}' > at.fa
