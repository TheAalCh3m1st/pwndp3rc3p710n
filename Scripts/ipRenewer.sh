#!/bin/bash

#Progress bar Section
# <-----Here----->
progress_bar() {
	local duration=$1
	local bar="#############################################################"
	local barlength=${#bar}
	local i=0

	while [ $i -lt $duration ]; do
		sleep 1
		i=$((i + 1))
		filled=$((i * barlength / duration))
		percent=$((i * 100 / duration))
		printf "\r[%-${barlength}s] %d%%" "${bar:0:filled}" "$percent"
	done
	echo ""
}

# Interface
# List Interfaces
echo "Available Networks:"
ip -o link show | awk -F': ' '{print $2}'
echo ""

# Ask user to choose interface
read -rp "Enter the intrface you want to configure:" IFACE
echo ""

# Ask for the IP in range of interface selected
read -p "Enter a new IP for $IFACE (excluding .1): " NEWIP

# Derive gateway (assume it's x.x.x.1 from IP given)
IFS='.' read -r o1 o2 o3 o4 <<< "$NEWIP"
GATEWAY="$o1.$o2.$o3.1"

echo ""
echo "Configuring interface $IFACE with IP $NEWIP/24 and gateway $GATEWAY"
echo ""

# Step 1 Flush existing IP
echo "[1/5] Assigning IP..."
sudo ip addr flush dev "$IFACE"
progress_bar 1

# Step 2: Assign new IP...
echo "[2/5] Assigning new IP..."
sudo ip addr add "$NEWIP"/24 dev "$IFACE"
progress_bar 1


# Step 3: Set new gateway
sudo ip route add default via "$GATEWAY" dev "$IFACE"
progress_bar 1

# Step 4: Bring interface down
sudo ip link set dev "$IFACE" down
progress_bar 1

# Step 5: Bring interface up
sudo ip link set dev "$IFACE" up
progress_bar 1

echo ""
echo "IP Refresh Sequence Complete!, New IP Configuration Applied!"
ip addr show dev "$IFACE"
