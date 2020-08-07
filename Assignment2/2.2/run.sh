#!/bin/bash

HF="../hostfile"
HL="../hostlist"

../../scripts/gen_hfl.sh $HL $HF

make clean
make


# echo "--> Iteration $i"
for D in $((64*(1<<10))) $((256*(1<<10))) $((512*(1<<10))) $((1<<21)) $((1<<22))
do
    echo -e "D = $D."
    for p in 8 16 32
    do
    echo -e "\tP = $p."
        for ppn in  2 4 8
        do
            filename="data/data$p-$ppn.dat"
            if [[ "$D" -eq "$((64*(1<<10)))" ]]; then
                rm -f $filename
            fi
            echo -ne "\t\tppn = $ppn..."
            for i in `seq 1 10`
            do
                mpiexec -n $p -ppn $ppn -hostfile $HF ./src.x $D >> $filename            
            done
            echo -e " done."
        done
        echo -e "\tp $p done."
    done
    echo -e "D $D done."
done

Rscript toboxall.r
