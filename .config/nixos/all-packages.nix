{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "15lb2x6xr33kwbaahgwz4pf0v494y0blxrja0518mfxsxxwdh1kp";
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
