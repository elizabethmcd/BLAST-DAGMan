# Directed Acyclic Graph Manager (DAGMan) for BLAST all-v-all on HTCondor

This subdirectory contains code for the DAGMan to run BLAST all-v-all on HTCondor. The goal of this workflow is to simply add protein files, press a button, and reproducibly create the workflow and data again and again without too much work/pain involved. The DAG overall performs such:

1. Forms a list of all `.faa` files in the current directory to a `genomes-list.txt` file for the blast databases to be made from all possible combinations.

2. Makes the blast databases for each genome

3. Writes the DAG for the BLAST function

4. Performs blast all-v-all blastp on all combinations of BLAST databases

5. Concatenates the files into one for further analyses, such as MCL on a local computer or the VM, because CHTC does weird things with MCL executables. As of 2017-11-11, I am trying to work on getting MCL to work through CHTC/DAG as well so the files don't have to be moved somewhere else for this. *Note: There are scripts in this directory for running MCL, but they are not part of the DAG workflow.*

## Run the Workflow:

1. Make some "results" directory. My preference is YYYY-MM-DD-identifying-info. Change the end of the `combine-cat.sh` script with the name of this directory to move the results file into at the end of the DAGMan. The initial repository gets messy really quickly.

2. Make a directory with all of your fasta files. If the file extension of the files is different than `.faa`, change the `make-combos.py` script with your specific file extension. Put the scripts in this directory.

3. To run the workflow on an HTCondor system: `condor_submit_dag blast-chtc.dag`. 


## Explanation of scripts and workflow:


`blast-chtc.dag` is the roadmap for this entire process. It maps out the sequential steps of the workflow, pre and post scripts, and the jobs for which submission and executable scripts should be called at which place in the workflow.

`blast.dag.config` contains pesky DAG requirements

All `.sub` files are condor submission files for the corresponding scripts.

`make-combos.py` makes the combinations of the files using the glob package, and writes out to a file to read from.

`makedb.sh` makes the BLAST databases using the local /makedb executable on CHTC.

`make-blast-dag.py` prepares the DAG for the BLAST all-v-all submission since it doesn't know a priori what databases to expect and the combinations to work off of.

`blast-all.sh` performs BLAST all-v-all

`combine-cat.sh` concatenates the BLAST all-v-all results into one giant file for further analyses, such as MCL that I will reference in another folder since I either have to do that on my local computer or the CCI VMs. Currently this script also filtes the blast results for MCL results. It also moves the results to a separate directory so you don't have to fish through the giant directory of BLAST databases and comparisons for your result files. So make that directory ahead of time.

## References:

[HTCondor Page on DAGMan](https://research.cs.wisc.edu/htcondor/dagman/dagman.html)
