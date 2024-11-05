#!/bin/bash

#A3 variant
result_pid=$((SOCAT_PID / 3))

#B3 variant
epoch_seconds=$(date +%s)
result_modulo=$((epoch_seconds % 5))

#index or error - values could ocassionally match 
if [[ $result_pid -eq $result_modulo ]]; then
    curl localhost:10000/index.html
else
    curl localhost:10000/error.html
fi
