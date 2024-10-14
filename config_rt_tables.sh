#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <number of routing tables>"
	exit 1
fi

count=$1
rt_file=/etc/iproute2/rt_tables

for ((i=1; i<=count; i++)); do
	entry="$i gw$i"

	if ! grep -q "$entry" $rt_file; then
		echo "Adding $entry..."
		echo "$entry" | sudo tee -a $rt_file > /dev/null
	else
		echo "$entry already exists"
	fi
done
