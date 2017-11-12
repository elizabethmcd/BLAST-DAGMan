#! /bin/bash

# Make blastdb and file extension

filename=$1

outname=${filename%.*}.db 

./makeblastdb -in $filename -out $outname -dbtype prot