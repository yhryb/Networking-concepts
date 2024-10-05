#!/bin/bash

while true
do
    echo "$(date):"
    top -b -o +%MEM | head -n 17
    sleep 180
done
