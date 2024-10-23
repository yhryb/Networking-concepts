#!/bin/bash

# Log file for server
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



