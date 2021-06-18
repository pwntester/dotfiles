#!/bin/bash 

iterations=10

# -----------------------------------------------------------------------------
# Create array of results

declare -a results

for i in $(seq 1 $iterations);
do
  nvim --startuptime vim.log -c 'q'
  latest=$(awk '/./{line=$0} END{print line}' vim.log | awk '{ print $1}')
  results+=( $latest )
done

# -----------------------------------------------------------------------------
# Calculate average

total=0
for delta in "${results[@]}"
do
  total=`echo $total + $delta | bc -l`
done

average=`echo $total / $iterations | bc -l`
echo $average
