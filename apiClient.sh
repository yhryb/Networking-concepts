#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "exactly 2 arguments needed - ip and port"
    exit 1
fi

SERVER_IP=$1 #first argument for ip
SERVER_PORT=$2

exec 3<>/dev/tcp/$SERVER_IP/$SERVER_PORT #connect to the server, creating a new descriptor

echo "Buonjorno!" >&3 #sending buonjorno with descriptor

read -u 3 serverResponse
echo "Server: $serverResponse"

if [[ "$serverResponse" == "Buonjorno! Your surname?" ]]; then
    echo "YourSurname" >&3  

    read -u 3 serverResponse
    echo "Server: $serverResponse"

    echo "Your DNS server?" >&3 

    read dnsServer
    echo "$dnsServer" >&3

    read -u 3 serverResponse
    echo "Server: $serverResponse"

    while true; do
        echo "Enter API command (or type 'exit' to quit): "
        read apiCommand

        if [[ "$apiCommand" == "exit" ]]; then
            break
        fi

        echo "$apiCommand" >&3
        
        read -u 3 serverResponse
         "Server Response: $serverResponse"
    done
else
    log "Invalid handshake response from server."
    exit 1
fi

exec 3>&- #closes descriptor

