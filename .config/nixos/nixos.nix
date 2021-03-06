# http://www.haskellforall.com/2018/08/nixos-in-production.html
let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz";
    sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
  };

in
  import "${nixpkgs}/nixos" {
    configuration = {
      imports = [
        ./configuration.nix
      ];
    };

    system = "x86_64-linux";
  }
