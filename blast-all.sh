#!/bin/bash
#
# blast.sh
# running blast with CHTC
#
echo "Hello CHTC from Job $1 of $2 vs $3 running on `whoami`@`hostname`"
chmod u+x blastp
chmod u+x blast_formatter
./blastp -seg yes -soft_masking true -use_sw_tback -evalue 1e-3 -outfmt 11 -db $2 -query $3 -out $2-vs-$3.blast
./blast_formatter -archive $2-vs-$3.blast -outfmt "6 std qcovs" -out $2-vs-$3.blast.outfmt6
rm $2-vs-$3.blast
