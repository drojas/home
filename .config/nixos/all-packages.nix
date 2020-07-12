{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
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
    # git
    brave
  ];
}
