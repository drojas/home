echo "Resolve nix env"
nix-env -iE "_: with import <nixpkgs/nixos> { configuration = {}; }; with config.system.build; [ nixos-generate-config nixos-install nixos-enter manual.manpages ]"

echo "Generate config"
mv hardwate-configuration.nix hardware-configuration.old.nix || true
mv configuration.nix configuration.old.nix || true
nixos-generate-config --dir .
