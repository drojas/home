{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "11pkc5mjr7yc6z6lx38vhqlhyia8ii452jaqyzy9m3kpfg255ah9";
    }))
  ];

  boot.cleanTmpDir = true;

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nix = {
    trustedUsers = [ "root" "david" ];
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  environment.systemPackages = with pkgs; [
    emacsGit
    vim
    brave
  ];
}
