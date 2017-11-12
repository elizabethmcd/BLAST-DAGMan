# Directed Acyclic Graph Manager (DAGMan) for BLAST all-v-all on HTCondor

This directory contains code for running BLAST all-v-all as a DAGMan on HTCondor. A Directed Acylic Graph Manager is a meta-schedule for HTCondor. This workflow is used to manage multiple dependencies between jobs. See References below for a full description of DAGMans and the manual.  

The goal of this workflow is to simply add protein files and reproducibly create BLASTP all-v-all comparisons without too much work/pain involved. The DAG overall performs such:

1. Forms a list of all `.faa` files in the current directory to a `genomes-list.txt` file for the blast databases to be made from all possible combinations.

2. Makes the blast databases for each protein file

3. Writes the DAG for the BLAST function

4. Performs blast all-v-all blastp on all combinations of BLAST databases

5. Concatenates the result files and `.faa` together for further analyses, such as MCL. As of 2017-11-11, I am trying to work on getting MCL to work through CHTC/DAG as well so the files don't have to be moved somewhere else for this.

## Run the Workflow:

1. Make some "results" directory. My preference is YYYY-MM-DD-identifying-info. Change the `combine-cat.sh` script with the name of this directory to move the results file into at the end of the DAGMan. The initial repository gets messy really quickly. Also change the names of the results files for the concatenated BLAST all-v-all results and the `.faa` files.

2. Make a directory with all of your fasta files. If the file extension of the files is different than `.faa`, change the `make-combos.py` script with your specific file extension. Put the scripts in this directory.

3. To run the workflow on an HTCondor system: `condor_submit_dag blast-chtc.dag`.

4. Your results are now in your specified results directory. What isn't included in these scripts are the added filtering steps I currently use. I use this workflow a lot for running the concatenated BLAST comparisons through MCL. I use such filtering steps at the end of the `combine-cat.sh` script:

### Filtering

```
awk ' $13 > 75 ' combined-blast-results.txt > 2017-10-13-combined-deltaprot.qcov75.results
awk ' $3 > 50 ' 2017-10-13-combined-deltaprot.qcov75.results > 2017-10-13-combined-deltaprot.qcov75.id50.results
awk ' $3 > 60 ' 2017-10-13-combined-deltaprot.qcov75.results > 2017-10-13-combined-deltaprot.qcov75.id60.results
awk ' $3 > 70 ' 2017-10-13-combined-deltaprot.qcov75.results > 2017-10-13-combined-deltaprot.qcov75.id70.results

# Filter the already filtered blast results to not have the qcov value, because MCL doesn't like it for whatever reason

for filename in *.results
  do cat $filename | cut -f1-12 > $filename.noqcov
done
```

Right now the scripts are set up just to move the concatenated raw comparison files and the combined `.faa` files to your results directory. This script is where you can change the filtering parameters.

## Explanation of Scripts:


`blast-chtc.dag` is the roadmap for this entire process. It maps out the sequential steps of the workflow, pre and post scripts, and the jobs for which submission and executable scripts should be called at which place in the workflow.

`blast.dag.config` contains pesky DAG requirements

All `.sub` files are condor submission files for the corresponding scripts.

`make-combos.py` makes the combinations of the files using the glob package, and writes out to a file to read from.

`makedb.sh` makes the BLAST databases using the local /makedb executable on CHTC.

`make-blast-dag.py` prepares the DAG for the BLAST all-v-all submission since it doesn't know a priori what databases to expect and the combinations to work off of.

`blast-all.sh` performs BLAST all-v-all

`combine-cat.sh` concatenates the BLAST all-v-all results into one giant file for further analyses. It also moves the results to a separate directory so you don't have to fish through the giant directory of BLAST databases and comparisons for your result files. So make that directory ahead of time.

## References:

- [HTCondor Page on DAGMan](https://research.cs.wisc.edu/htcondor/dagman/dagman.html)
- Shoutout to [Sarah Stevens](https://github.com/sstevens2) for giving me the idea to run this analysis as a DAGMan and for helping me in the initial stages as I banged my head against the wall that is HTCondor.

## Issues/Questions:

If you run into any problems with this workflow, please feel free to submit an Issue or email me at [emcdaniel@wisc.edu](mailto:emcdaniel@wisc.edu). If you have any suggestions about downstream analyses that could be added to this DAGMan, such as MCL (which I have yet to get working through HTCondor because of pesky problems with moving MCL executables), please also contact me!
