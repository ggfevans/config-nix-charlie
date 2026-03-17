# nix-charlie

NixOS configuration for a 2018 MacBook Pro (T2 chip), running as a headless homelab server.

## Firmware

The `firmware/brcm/` directory is gitignored — it contains Apple's proprietary
Wi-Fi/Bluetooth firmware which can't be redistributed. To regenerate:
```bash
sudo mkdir -p /lib/firmware/brcm
get-apple-firmware  # select "Retrieve from macOS" or "Download recovery image"
cp /lib/firmware/brcm/* ~/nixos-config/firmware/brcm/
```

## Rebuild
```bash
sudo nixos-rebuild switch --flake ~/nixos-config
```
