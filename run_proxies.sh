#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage: <dongle interface 1> <dongle interface 2> ..."
	exit 1
fi

dongle_array=($@)
echo ${dongle_array[@]}
exit 1

idx=0
conf_dir="configs"

for dongle in "${dongle_array[@]}"; do
	ip=$((100+idx))
	table=gw$((idx+1))
	conf_file=$((idx+1)).cfg

	echo "Setting up $dongle IP..."
	sudo ifconfig $dongle 192.168.0.$ip
	sleep 2

	echo "Setting up $dongle $table table routing..."
	sudo ip route add 192.168.0.0/24 dev $dongle src 192.168.0.$ip table $table
	sudo ip route add default via 192.168.0.1 dev $dongle table $table
	sudo ip rule add from 192.168.0.$ip/32 table $table
	sudo ip rule add to 192.168.0.$ip/32 table $table
	sleep 2

	echo "Starting 3proxy number $((i+1))"
	3proxy $conf_dir/3proxy$((idx+1)).conf

	idx=$((idx+1))
done

echo "Starting HAProxy..."
sudo haproxy -f $conf_dir/haproxy.cfg

echo "Done"
