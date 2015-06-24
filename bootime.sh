#!/bin/bash
NAMEINTERFACE="eth0"
ABSOLHOST="nymphae.meteor.com"
ABSOLPATH="/opt/nymphae-client"

line=$(head -n 1 $ABSOLPATH/datas)

if [ "$line" != "stop-all-bootime" ]; then
	INTERRUPT=0

	while [ "$INTERRUPT" -eq 0 ]; do
		macAddress="$(cat /sys/class/net/$NAMEINTERFACE/address | tail -c 9)"
		macAddressReformat="${macAddress//:}"
		response="$(curl -s -d"{\"macAddress\":\"$macAddressReformat\",\"firstTime\":true}" -i -X POST -H "Content-Type:application/json" http://$ABSOLHOST/api/devices)"
		respFirstLine="$(printf %s $response)"

		flag=`echo $respFirstLine|awk '{print match($0,"success")}'`;
		if [ $flag -gt 0 ];then
			INTERRUPT=1
		else
			sleep 1
		fi

	done
	echo "stop-all-bootime" > $ABSOLPATH/datas
	python $ABSOLPATH/lcd.py $macAddressReformat
fi
