#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <server_ip> <server_port>"
    exit 1
fi

SERVER_IP=$1 #first argument for ip
SERVER_PORT=$2

exec 3<>/dev/tcp/$SERVER_IP/$SERVER_PORT || { echo "Failed to connect to server"; exit 1; }#connect to the server, creating a new descriptor

echo "Buonjorno!" >&3 #sending buonjorno with descriptor

read -u 3 serverResponse
echo "Server: $serverResponse"

if [[ "$serverResponse" == "Buonjorno! Your surname?" ]]; then
    echo "YourSurname" >&3  

    read -u 3 serverResponse
    echo "Server: $serverResponse"

    echo "Your DNS server?" >&3 

    echo "192.168.64.6" >&3
    read -u 3 serverResponse
    echo "Server: $serverResponse"

    while true; do
        echo "Enter API command (GetAlbumBySong <song_name>, GetSongsOfPerformer <performer_name>, exit): "
        read apiCommand commandParam

        if [[ "$apiCommand" == "exit" ]]; then
            echo "exit" >&3
            read -u 3 serverResponse #waiting for server response before breaking the loop
            echo "Server: $serverResponse"
            break

            echo "Goodbye" >&3
            read -u 3 serverResponse
            echo "Server: $serverResponse"
            break
        fi

        echo "$apiCommand $commandParam" >&3
        
        read -u 3 serverResponse
        echo "Server Response: $serverResponse"
    done
else
    echo "Invalid handshake response from server."
    exit 1
fi

exec 3>&- #closes descriptor

