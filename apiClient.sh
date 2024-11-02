#!/bin/bash

# Check if the correct number of arguments is provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <server_ip> <server_port>"
    exit 1
fi

SERVER_IP=$1
SERVER_PORT=$2

# Connect to the server, creating a new descriptor
exec 3<>/dev/tcp/$SERVER_IP/$SERVER_PORT || { echo "Failed to connect to server"; exit 1; }

# Begin handshake with "Buonjorno!"
echo "Buonjorno!" >&3
while read -u 3 serverResponse; do
    echo "Server: $serverResponse"
    if [[ "$serverResponse" == "Buonjorno! Your surname?" ]]; then
        break
    fi
done

# Proceed with sending surname and DNS server details
echo "SomeSurname" >&3
while read -u 3 serverResponse; do
    echo "Server: $serverResponse"
    if [[ "$serverResponse" == "Your DNS server?" ]]; then
        break
    fi
done

echo "192.168.64.6" >&3
while read -u 3 serverResponse; do
    echo "Server: $serverResponse"
    if [[ "$serverResponse" == "Ok. Ready." ]]; then
        break
    fi
done

#goodbye message - when server says ill be back it is a signal the server is ready to receive commands
while read -u 3 serverResponse; do
    echo "Server: $serverResponse"
    if [[ "$serverResponse" == "I'll be back!" ]]; then
        break
    fi
done

# Main command loop
while true; do
    echo "Enter API command (GetAlbumBySong <song_name>, GetSongsOfPerformer <performer_name>, exit): "
    read apiCommand commandParam

    # Exit condition
    if [[ "$apiCommand" == "exit" ]]; then
        echo "exit" >&3
        # Wait for the closing message
        while read -u 3 serverResponse; do
            echo "Server: $serverResponse"
            if [[ "$serverResponse" == "Closing connection." ]]; then
                break
            fi
        done
        break
    fi

    # Send command to the server and read response
    echo "$apiCommand $commandParam" >&3
    while read -u 3 serverResponse; do
        echo "Server Response: $serverResponse"
        if [[ "$serverResponse" == "END" ]]; then
            break
        fi
    done
done

# Close the connection
exec 3>&-


