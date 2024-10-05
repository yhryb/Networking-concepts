#!/bin/bash

while true
do
    echo "$(date):"
    top -b -o +%MEM | head -n 17 
    #top for memory usage, -b for batch mode, -o +%MEM for memory usage output in ascending order; 
    #head -n 17 so the script outputs only the first 17 lines
    sleep 180
    #repeats every 3 minutes
done
