nix-build --attr system "./nixos.nix" -o result-closure
readlink -f result-closure > closure-nix-store-path.txt
rm -r system
mkdir system
nix copy ./result-closure --to file://./system