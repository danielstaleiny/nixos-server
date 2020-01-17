#!/usr/bin/env bash

VERSION="19.09"
nix-prefetch-git --url https://github.com/NixOS/nixpkgs-channels --rev refs/heads/nixos-$VERSION > pinned/nixpkgs.json
