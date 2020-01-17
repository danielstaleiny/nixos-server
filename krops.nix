#
let
  krops = builtins.fetchGit {
    url = "https://github.com/danielstaleiny/krops.git";
  };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" {};
  importJson = (import <nixpkgs> {}).lib.importJSON;

  ip = import ./ip.nix;

  source =  lib.evalSource [
    {
      # use it for storing keys, 
      # env variables
      # stuff like that to create trully deterministic server
      # secrets.pass = {
      #   dir  = toString /home/anon/.password-store;
      #   name = "krops";
      # };

      #     "nixos".file = toString ./nixos;
      #     "configuration.nix".symlink = "/etc/nixos/configuration.nix";

      nixpkgs.git = {
        #       nix-prefetch-git --url https://github.com/NixOS/nixpkgs-channels \
        #         --rev refs/heads/nixos-19.09 \
        #         > nixpkgs.json
        ref = (importJson ./pinned/nixpkgs.json).rev;
        url = https://github.com/NixOS/nixpkgs-channels;
      };

      nixos-config.file = toString ./nixos/configuration.nix;
      "hardware-configuration.nix".file = toString ./nixos/hardware-configuration.nix;
      "networking.nix".file = toString ./nixos/networking.nix;
      "allowed_keys".file = toString ./nixos/allowed_keys;
    }
  ];


  ssh = lib.concatStrings ["nixbuilder@" ip];
  root = "/home/nixbuilder/nixos";
  prod = pkgs.krops.writeDeploy "production-server01" {
    source = source;
    target = lib.concatStrings [ ssh root];
  };

in {
  prod = prod;

  all = pkgs.writeScript "deploy-all-servers"
    (lib.concatStringsSep "\n" [ prod ]);
}

