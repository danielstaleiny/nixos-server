#!/usr/bin/env bash
# give ownership to nixbuilder user on IP server
# takes the auto generated config files
IP=$(grep -iPo '(?<=ip = ")(.*)(?=";)' ./ip.nix)

USER="nixbuilder"

if [[ -n $IP ]]; then
    ssh root@$IP -oStrictHostKeyChecking=accept-new chown -R nixbuilder /home/nixbuilder/nixos
    scp $USER@$IP:nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
    scp $USER@$IP:nixos/networking.nix ./nixos/networking.nix
else
    echo "IP address argument missing."
fi
