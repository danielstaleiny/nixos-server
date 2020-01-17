#
# Create symlink for configuration, allowed_keys folder, hardware-configuration
{pkgs, ... }:

let
  # xps15 = toString ./allowed_keys/xps15;
  # work = toString ./allowed_keys/work;
in
{
  imports = [
    ./hardware-configuration.nix # generated
    ./networking.nix # generated at runtime by nixos-infect
    #    ./cron-jobs.nix


  ];

  boot.cleanTmpDir = true;
  networking.hostName = "server";
  networking.firewall.allowPing = true;
  time.timeZone = "Europe/Copenhagen";

  environment.systemPackages = with pkgs; [
    wget
    git
    neovim
  ];

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  #  services.openssh.permitRootLogin = "no";

  # users.users.root.openssh.authorizedKeys.keyFiles = [ xps15 work ];
  # users.users.nixbuilder.openssh.authorizedKeys.keyFiles = [ xps15 work ];
  # users.users.admin.openssh.authorizedKeys.keyFiles = [ xps15 work ];



  users.users.nixbuilder = {
    isNormalUser = true;
    uid = 1100;
    description = "User to modify configuration";
    extraGroups = [ ];
  };

  users.users.admin = {
    isNormalUser = true;
    description = "Administrator";
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

 security.sudo.extraRules = [ { commands = [ { command = "/run/current-system/sw/bin/nixos-rebuild"; options = [ "SETENV" "NOPASSWD" ] ; } ]; groups = [ 1100 ] ; users = [ "nixbuilder" ] ; }];


  # clean without removing old configuration
  #nix.gc.automatic = true;
  #nix.gc.dates = "03:15";

  system.autoUpgrade.enable = true;
  system.stateVersion = "19.09";

}
