echo "create GPT partition table"
parted -s -a optimal -- /dev/nvme0n1 mklabel gpt

echo "create root partition"
parted -s -a optimal -- /dev/nvme0n1 mkpart primary 512MiB -32GiB

echo "create swap partition"
parted -s -a optimal -- /dev/nvme0n1 mkpart primary -8GiB 100%

echo "create boot partition"
parted -s -a optimal -- /dev/nvme0n1 mkpart ESP 1MiB 512MiB
parted /dev/nvme0n1 -- set 3 boot on

echo "format root partition"
mkfs.ext4 -L nixos /dev/nvme0n1p1

echo "format boot partition"
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

echo "format swap partition"
mkswap -L swap /dev/nvme0n1p2

sleep 1

echo "mount target filesystem"
mount /dev/disk/by-label/nixos /mnt

echo "mount boot partition"
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "activate swap"
swapon /dev/nvme0n1p2

echo "copy closure to nix store"
nix copy --from file:///etc/system $(cat /etc/closure-nix-store-path.txt) --option binary-caches "" --no-check-sigs

echo "install nix"
nixos-install --no-root-passwd --option binary-caches "" --system $(cat /etc/closure-nix-store-path.txt)
