#!/bin/bash
set -ex
IFNAME=$1
DNS_ENTRIES=$2
ADDRESS="$(ip -4 addr show "$IFNAME" | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-jammy entry
sed -e '/^.*ubuntu-jammy.*/d' -i /etc/hosts
sed -e "/^.*$2.*/d" -i /etc/hosts

# Create the text block
host_values=$(echo "$DNS_ENTRIES" | sed 's/,/\n/g')

# Append the text block to /etc/hosts
# Update /etc/hosts about other hosts
cat >>/etc/hosts <<EOF
$host_values
EOF
