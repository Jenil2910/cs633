#!/bin/bash

HF="../hostfile"
HL="../hostlist"
HMS="heatmap.py"

../../scripts/gen_hfl.sh $HL $HF
make

for D in $((64*(1<<10))) $((512*(1<<10))) $((1<<21))
do
    rm -f data/data-$D.dat
    echo -ne "$D "
    for i in `seq 1 10`
    do
        echo -ne "$i "
        mpiexec -n 30 -hostfile ../hostfile ./src.x $D >> data/data-$D.dat
    done
    echo "done."
done

for D in $((64*(1<<10))) $((512*(1<<10))) $((1<<21))
do
    python3.6 heatmap.py data/data-$D.dat plot/plot0-$D.png 0
    python3.6 heatmap.py data/data-$D.dat plot/plot1-$D.png 1
done
