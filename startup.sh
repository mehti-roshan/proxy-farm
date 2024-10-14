#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <default wired interface name>"
	exit 1
fi

main_interface=$1
interfaces=()

for iface in /sys/class/net/*; do
	iface_name=$(basename $iface)
	if [ $(cat $iface/operstate) == "up" ]; then
		interfaces+=($iface_name)
	fi
done

num_of_interfaces=${#interfaces[@]}
num_of_dongles=$((num_of_interfaces-1))

dongles=()
for iface in ${interfaces[@]}; do
	if [ "$iface" != "$main_interface" ]; then
		dongles+=($iface)
	fi
done

./enable_ip_forward.sh
./config_rt_tables.sh $num_of_dongles
./generate_configs.sh $num_of_dongles
./run_proxies.sh ${dongles[@]}
