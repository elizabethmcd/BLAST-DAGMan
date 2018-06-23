#! /usr/bin/python

import glob 

# Make a list of genomes

genomelist = glob.glob("*.faa")

# Write file with list of genomes

with open("genome-list.txt", "w") as output:
	for genome in genomelist:
		output.write(genome + "\n")

# BLAST combinations list

with open ("blast-combos.txt", "w") as combos:
	for file1 in genomelist:
		file1 = file1.split(".faa") [0] + (".db")
		for file2 in genomelist:
			combos.write(file1 + "," + file2 + "\n")
