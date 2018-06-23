#! /bin/bash

# All db comparisons in one file
cat *.outfmt6 > combined-blast-results.txt

# combine fasta files for dicts
cat *.faa > combined-proteins.faa


# Move results files
mkdir results
mv combined-proteins.faa results/
mv combined-blast-results.txt results/
