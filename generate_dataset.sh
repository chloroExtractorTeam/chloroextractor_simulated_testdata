#!/bin/bash

# download sequence files
cd /tmp/
wget -O mt.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_001284.2&extrafeat=976&maxplex=1'
wget -O pltd.fasta 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=fasta&id=NC_000932.1&extrafeat=976&maxplex=1'

# generate a concatinated chloroplast-genome of 200x normal chloroplast
(sed -n '1p' pltd.fasta; for i in $(seq 1 300); do sed '1d' pltd.fasta; done) | sed '/^$/d' > 300pltd.fasta
# generate a concatinated mitochondrion-genome of 50x normal mitochondrion
(sed -n '1p' mt.fasta; for i in $(seq 1 50); do sed '1d' mt.fasta; done) | sed '/^$/d' > 50mt.fasta

# combine all sequences and 
cat 300pltd.fasta 50mt.fasta | sed '/^>/{s/^\(>[^[:space:]]*\).*/\1/g}' > at.fa

# download and extract art
wget https://www.niehs.nih.gov/research/resources/assets/docs/artbinmountrainier20160605linux64tgz.tgz
tar xzf artbinmountrainier20160605linux64tgz.tgz

# simulate reads using art
art_bin_MountRainier/art_illumina --in at.fa --seqSys HS25 --samout --paired --out at_simulated --len 150 --sdev 50 --mflen 500 --fcov 1 --rndSeed 1505309059 &>art.log

# calculate checksums
md5sum art.log at_simulated1.fq at_simulated2.fq >MD5SUM

# create archive
tar cf - at_simulated1.fq at_simulated2.fq art.log MD5SUM | pbzip2 --verbose -9 --compress --stdout > /data/art_result.tar.bz2
