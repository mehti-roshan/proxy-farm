#!/bin/bash

count=$1
haproxy_port=3128
port_start=8080
conf_dir="configs"

# Go to the conf dir to create all the files in there
cd $conf_dir

echo "Generating 3proxy configurations..."
for ((i=0; i<$count; i++)); do
	filename=3proxy$((i+1)).conf
	port=$((port_start+i))
	ip=$((100+i))

	cat <<EOF > $filename
daemon
nserver 8.8.8.8
nscache 65536
auth none
allow all
timeouts 1 5 30 60 180 15 60

proxy -p$port -e192.168.0.$ip
flush

EOF
done

echo "Generating haproxy configuration..."
cat <<EOF > haproxy.cfg
global
	user haproxy
	group haproxy
	daemon
	stats timeout 30s

defaults
	timeout connect 5000ms
	timeout client 50000ms
	timeout server 50000ms

frontend proxy_front
	bind localhost:3128
	default_backend proxy_back

backend proxy_back
	balance roundrobin
EOF

for ((i=0; i<$count; i++)); do
	proxy_num=$((i+1))
	port=$((port_start+i))

	cat <<EOF >> haproxy.cfg
	server proxy$proxy_num 127.0.0.1:$port check
EOF
done

# Change back to the parent directory
cd ../
