#!/bin/bash
datafile='data.dat'
rm -f $datafile
for i in {128,1024,65536,1048576,4194304};
do
	for j in `seq 1 5`;do
		mpiexec -np 2 -f ../../hostfile ./src.x $i >> $datafile
	done
	echo "$i done"
done

gnuplot tobox.gnuplot
