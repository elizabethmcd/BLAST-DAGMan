#! /usr/bin/python
# DAG for blast comparison 

import sys 

with open(sys.argv[1], 'r') as c:
	combolist = c.readlines()
	
with open("blast.dag" , "w") as combodag:
	for i, combo in enumerate(combolist):
		f1, f2 = combo.split(',')
		f2=f2.rstrip("\n")
		combodag.write('JOB combo{0} blast-all.sub\n'.format(i))
		combodag.write('VARS combo{0}  db="{1}" query="{2}"\n'.format(i, f1, f2))
		

