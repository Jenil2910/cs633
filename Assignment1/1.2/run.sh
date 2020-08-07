#!/bin/bash

set +x

datapref='./data/data'
rm -f `echo "$datapref""*"` #"$datapref""*"
D=(1024 65536 262144 1048576)
P=(8 16 32)
for p in ${P[@]}; do
	n=$(($p/4))
	datafilenb="$datapref""$p""_nb.dat"
	datafileb="$datapref""$p""_b.dat"
	for d in ${D[@]}; do
	        for i in {1..5};do
			ppn=$(cat ../../hostfile | head -$n | perl -p -e 's/\n/:4,/g' | perl -p -e 's/.$//g')
			mpiexec -np $p -host $ppn ./src_nb.x $d >> $datafilenb
			mpiexec -np $p -host $ppn ./src_nb.x $d >> $datafileb
		done
		echo "$p $d done"
	done
done

##For Cleaning up data files for input to gnuplot
#df=( $(ls './data') )
#for f in ${df[@]}; do
#	F=`echo "./data/$f"`
#	cat $F | perl -pe 's/^[= ].*//g' | tr -s '\n' > /tmp/t
#	cat /tmp/t > $F
#	echo "Cleaned $F"
#done

Rscript toboxall.r

set -x
