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
read -u 3 serverResponse
echo "Server: $serverResponse"

# Validate server handshake response
if [[ "$serverResponse" != "Buonjorno! Your surname?" ]]; then
    echo "Invalid handshake response from server."
    exit 1
fi

# Proceed with sending surname and DNS server details
echo "YourSurname" >&3  
read -u 3 serverResponse
echo "Server: $serverResponse"

echo "Your DNS server?" >&3
echo "192.168.64.6" >&3
read -u 3 serverResponse
echo "Server: $serverResponse"

# Main command loop
while true; do
    echo "Enter API command (GetAlbumBySong <song_name>, GetSongsOfPerformer <performer_name>, exit): "
    read apiCommand commandParam

    # Exit condition
    if [[ "$apiCommand" == "exit" ]]; then
        echo "exit" >&3
        read -u 3 serverResponse
        echo "Server: $serverResponse"
        
        # Send a goodbye message to the server before exiting
        echo "Goodbye" >&3
        read -u 3 serverResponse
        echo "Server: $serverResponse"
        break
    fi

    # Send command to the server and read response
    echo "$apiCommand $commandParam" >&3
    read -u 3 serverResponse
    echo "Server Response: $serverResponse"
done

# Close the connection
exec 3>&-


