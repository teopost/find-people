#!/bin/bash

if [ ""$1 = "" ];then
  echo "usage: find-people.sh people.dat"
  exit
fi


function already_notified(){
#torna true se e' gia' stato notificato
lockname=$1-$(date +%Y-%m-%d).dat

if [ ! -f locks/$lockname ]; then
    echo 0
else 
    echo 1
fi
}

save_notification() {
date > locks/$1-$(date +%Y-%m-%d).dat
}


# MAIN
# ====
while read line; do
    code=$(echo $line | cut -d"," -f 1)
    name=$(echo $line | cut -d"," -f 2)
    ip=$(echo $line | cut -d"," -f 3)
    mac=$(echo $line | cut -d"," -f 4)

    echo -n "Looking for: " $name

    result=$(/usr/sbin/arping -c 1 -b $ip)
    if [ $? -eq 0 ];then
      ipfound=1
    else
      ipfound=0
    fi 

    resultmac=$(echo $result | grep $mac | wc -l)
    if [ $resultmac -eq 0 ];then
       macfound=0
    else
       macfound=1
    fi
   
    if [[ $ipfound -eq 1 && $macfound -eq 1 ]]; then
       echo -n "... YES is HERE!!!"
       if [ $(already_notified $code)  -eq 1 ];then
           echo "..already notified..."
       else
           echo "..send notification..."
           save_notification $code
           ./telegram "$name is connected to Tecla lan"
       fi
    else
       echo "... missing!"
    fi

done < $1

#find ./locks/*.dat  -mtime +5
