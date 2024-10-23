#!/bin/bash

LOGFILE="/var/log/apiServer.log"

socat -T30 TCP-LISTEN:4242,fork EXEC:"/usr/bin/apiServer.sh",pty,setsid,ctty & #timeout if 30 seconds no response; fork is to fork a new process each time

echo "Server listening on port 4242..."

log() {
  echo "$(date) - $1" >> $LOGFILE #$logfile appends to the logfile
}

read clientMessage #storing input in clientMessage

if [[ "$clientMessage" != "Buonjorno!" ]]; then #recognising only Buonjorno
  echo "Connection dropped: Invalid handshake start"
  log "Invalid handshake start from client"
  exit 1
fi

echo "Buonjorno! Your surname?"

read someSurname

echo "Your DNS server?"

read dnsServer

echo "Ok. Ready."

log "Handshake complete with surname: $someSurname and DNS server: $dnsServer"

fetchFromDB() {
  local searchField=$1
  local searchValue=$2
  result=$(grep -i "$searchValue" db.txt | awk -F';' -v field="$searchField" '{ print $field }')
  if [[ -z "$result" ]]; then
    echo "No match found for $searchValue."
  else
    echo "$result"
  fi
}

while true; do
  echo "Enter API command:"
  read apiCommand

  case "$apiCommand" in
    "get_album_by_song")
      echo "Enter song name:"
      read songName
      album=$(fetchFromDB 3 "$songName")
      echo "Album: $album"
      log "Fetched album for song '$songName': $album"
      ;;
    
    "get_songs_by_performer")
      echo "Enter performer name:"
      read performerName
      songs=$(fetchFromDB 1 "$performerName")
      echo "Songs by $performerName: $songs"
      log "Fetched songs by performer '$performerName': $songs"
      ;;
    
    "exit")
      echo "Closing connection."
      log "Client disconnected."
      break
      ;;

    *)
      echo "Invalid command."
      log "Invalid command received: $apiCommand"
      ;;
  esac
done



