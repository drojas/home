{ config, pkgs, lib, ... }:

let
  paperwm = pkgs.stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-paperwm";
    version = "36.0";

    src = pkgs.fetchFromGitHub {
      owner = "paperwm";
      repo = "PaperWM";
      rev = version;
      sha256 = "1ssnabwxrns36c61ppspjkr9i3qifv08pf2jpwl7cjv3pvyn4kly";
    };

    uuid = "paperwm@hedning:matrix.org";

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions/${uuid}
      cp -r . $out/share/gnome-shell/extensions/${uuid}
    '';

    meta = with lib; {
      description = "Tiled scrollable window management for Gnome Shell";
      homepage = "https://github.com/paperwm/PaperWM";
      license = licenses.gpl3;
      maintainers = with maintainers; [ hedning zowoq ];
    };
  };
in

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
    paperwm
    gnome3.gnome-tweaks
  ];
}
