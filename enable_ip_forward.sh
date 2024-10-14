#!/bin/bash

current_forwarding=$(sudo sysctl net.ipv4.ip_forward | awk '{print $3}')
if [ $current_forwarding -ne 1 ]; then
	echo "Enabling IP forwarding..."
	sudo sysctl -w net.ipv4.ip_forward=1
else
	echo "IP forwarding already enabled"
fi
