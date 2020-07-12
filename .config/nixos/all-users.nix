{ config, pkgs, lib, ... }:

let
  username = "david";
in {
  imports = [
    (builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz";
    } + "/nixos/default.nix")
  ];
  users.extraUsers."${username}" = {
    uid = 1000;
    isNormalUser = true;
    name = username;
    group = username;
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "networkmanager" "systemd-journal"
      "docker"
      "kubernetes"
    ];
    createHome = true;
    home = "/home/${username}";
    openssh.authorizedKeys.keys = [
    ];
    packages = with pkgs; [
    ];
    hashedPassword = "$6$qIaDNdNn$ItbYPCv5RnfBG4UKP/ySb1e16TW9URoKQ.XjKfwxvisdZXtt7AgS5waXf/1lW4vvBv016X0R8UprzUBbHuffN0";
  };

  users.extraGroups.${username} = {
    gid = 1000;
  };

  home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;
  home-manager.users."${username}" = (import ../nixpkgs/home.nix);
}
