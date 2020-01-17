#!/usr/bin/env bash
# deploys newest changes to production

nix-build ./krops.nix -A prod && ./result
