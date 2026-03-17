#!/usr/bin/env bash
# deploy.sh — run from your local machine
set -euo pipefail

HOST="nix-charlie"

echo "Pushing to GitHub..."
git push

echo "Rebuilding on nix-charlie..."
ssh $HOST \
  "cd ~/nixos-config && git pull && sudo nixos-rebuild switch --flake ~/nixos-config 2>&1"

echo "Done."
