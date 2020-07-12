{ config, pkgs, ... }:

{
  imports = [
    # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # add the automated installation files
  environment.etc = {
    "install.sh" = {
      source = ./install.sh;
      mode = "0700";
    };
    "closure-nix-store-path.txt" = {
      source = ./closure-nix-store-path.txt;
    };
    "system" = {
      source = ./system;
    };
  };

  # automatically run install script
  environment.etc."profile.local".text = ''
    sudo /etc/install.sh && reboot
  '';


}
