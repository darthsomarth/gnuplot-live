#!/bin/bash
TMPDIR=$(mktemp -d)
NPIPE="${TMPDIR}/pipe1"
DFILE="${TMPDIR}/to-plot.txt"
mkfifo $NPIPE
BINS=${1:-10}
trap cleanup SIGINT
function cleanup {
        echo "exit" > $NPIPE
        exec 3>&-
        rm -rf $TMPDIR 
        exit
} 
gnuplot < $NPIPE &
exec 3>$NPIPE 
echo "set term qt noraise;set xrange [0:$((BINS-1))]" > $NPIPE
while read line
do
        echo "${line}" >> $DFILE
        FIELDS=$(echo "${line}" | awk '{print NF}')
        echo "plot for [col=1:${FIELDS}] '< tail -n ${BINS} ${DFILE}' u 0:col w lp t 'COL'.col" > $NPIPE
done < /dev/stdin
