#!/bin/bash
# exports every foundation-base section for both printers
cd /home/claude/scad/Basement
job(){ P=$1; B=$2; T=$3; D=$([ $P = GIGA ] && echo GIGA || echo P1S)
  openscad -D "PRINTER=\"$P\"" -D "BUILDING=\"$B\"" -D "TILE=$T" -o /home/claude/stl/$D/Foundation_${B}_${P}_part$(printf %02d $((T+1))).stl foundation_base.scad > /home/claude/stl/$D/log_${B}_$T.txt 2>&1; }
export -f job
{ for t in $(seq 0 11); do echo "P1S main $t"; done
  for t in 0 1 2 3; do echo "P1S baggage $t"; done
  for t in 0 1; do echo "GIGA main $t"; done
  echo "GIGA baggage 0"; } | xargs -P 2 -L 1 bash -c 'job $0 $1 $2'
