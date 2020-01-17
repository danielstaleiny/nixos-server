#!/usr/bin/env bash
# pass ubuntu 16 LTS IP on digitalocean

IP=$(grep -iPo '(?<=ip = ")(.*)(?=";)' ./ip.nix)

if [[ -n $IP ]]; then
    echo "updating channels"
    ./scripts/channel-update.sh

    # 1 liner
    ssh root@$IP -oStrictHostKeyChecking=accept-new git clone https://github.com/danielstaleiny/nixos-infect.git
    ssh root@$IP "cd nixos-infect; ./nixos-infect"

    echo "*****"
    echo "It takes approx 10min for server to reboot and nixos taking over."
    echo "Sleeping for 10min"
    echo "*****"
    sleep 10m
    sed "/$IP/d" ~/.ssh/known_hosts > ~/.ssh/known_hosts
    echo "runing hook, giving ownership of the server to nixbuilder"
    ./scripts/give-owneship-nixbuilder.sh
else
    echo "IP address argument missing."
fi
