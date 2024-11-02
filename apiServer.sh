#!/bin/bash

LOGFILE="/var/log/apiServer.log"

log() {
  echo "$(date) - $1" >> $LOGFILE #$logfile appends to the logfile
}

read clientMessage #storing input in clientMessage

if [[ "$clientMessage" != "Buonjorno!" ]]; then #recognising only Buonjorno
  echo "Connection dropped: Invalid handshake start"
  log "Invalid handshake start from client"
  echo "END"
  exit 1
fi

echo "Buonjorno! Your surname?"
echo "END"

read -r someSurname

if [[ ! "$someSurname" =~ ^[a-zA-Z]+$ ]]; then
  echo "Invalid surname format. Disconnecting."
  log "Invalid surname format: $someSurname"
  echo "END"
  exit 1
fi

echo "Your DNS server?"
echo "END"

read -r dnsServer

if [[ ! "$dnsServer" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "Invalid DNS format. Disconnecting."
  log "Invalid DNS format: $dnsServer"
  echo "END"
  exit 1
fi

echo "Ok. Ready."

log "Handshake complete with surname: $someSurname and DNS server: $dnsServer"

fetchFromDB() {
  local searchField=$1
  local searchValue=$2
  result=$(grep -i "$searchValue" /etc/apiService/db.txt | awk -F';' -v field="$searchField" '{ print $field }')
  if [[ -z "$result" ]]; then
    echo "No match found for $searchValue."
  else
    echo "$result"
  fi
  echo "END"
}

while true; do
  echo "Enter API command:"
  echo "END"
  read -r apiCommand apiParam

  case "$apiCommand" in
    "exit")
      echo "Closing connection."
      log "Client disconnected."
      echo "END"
      break
      ;;
    "GetAlbumBySong")
      album=$(fetchFromDB 3 "$apiParam")
      echo "Album: $album"
      log "Fetched album for song '$apiParam': $album"
      echo "END"
      ;;
    "GetSongsByPerformer")
      songs=$(fetchFromDB 1 "$apiParam")
      echo "Songs by $apiParam: $songs"
      log "Fetched songs by performer '$apiParam': $songs"
      echo "END"
      ;;
    *)
      echo "Invalid command."
      log "Invalid command received: $apiCommand $apiParam"
      echo "END"
      ;;
  esac
done


