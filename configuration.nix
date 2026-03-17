{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./headless.nix
  ];

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
    configurationLimit = 20;  # prevent EFI partition filling up (shared with macOS)
  };
  boot.loader.timeout = 5;

  # Networking
  networking.hostName = "nix-charlie";
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 42042 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Tailscale
  services.tailscale.enable = true;

  # Timezone & locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.gvns = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # SSH — hardened, port 42042
  services.openssh = {
    enable = true;
    ports = [ 42042 ];
    settings = {
      PermitRootLogin = "prohibit-password";
      MaxAuthTries = 10;
      MaxSessions = 3;
      PubkeyAuthentication = "yes";
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;
      KbdInteractiveAuthentication = false;
      UsePAM = true;
      AllowAgentForwarding = true;
      PrintMotd = false;
    };
  };

  # Terminal/tmux (needed for Warp warpify)
  programs.tmux.enable = true;
  environment.enableAllTerminfo = true;

  # Dynamic linker compatibility (needed for Zed remote server)
  programs.nix-ld.enable = true;

  # Git
    programs.git = {
      enable = true;
      config = {
        user.name = "ggfevans";
        user.email = "hi@gvns.ca";
      };
    };

  # Wi-Fi firmware (Broadcom from macOS)
  hardware.firmware = [
      (pkgs.stdenvNoCC.mkDerivation (final: {
        name = "brcm-firmware";
        src = ./firmware/brcm;
        installPhase = ''
          mkdir -p $out/lib/firmware/brcm
          cp ${final.src}/* "$out/lib/firmware/brcm"
        '';
      }))
    ];

  # Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    htop
    fastfetch
    curl
    efibootmgr
    lm_sensors
    smartmontools
    iotop
  ];

  system.stateVersion = "25.11";
}
