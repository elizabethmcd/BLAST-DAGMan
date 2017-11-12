#! /bin/bash

# All db comparisons in one file
cat *.outfmt6 > combined-blast-results.txt

# combine fasta files for dicts
cat *.faa > combined-deltaprot-proteins.faa


# Move results files
mv *.noqcov /home/emcdaniel/2017-10-13-results/
mv combined-deltaprot-proteins.faa /home/emcdaniel/2017-10-13-results/
