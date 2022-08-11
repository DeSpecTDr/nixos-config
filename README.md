# My [NixOS](https://nixos.org) config

# Filesystem setup:

## laptop:

/boot FAT32 512M

/dev/mapper/cryptlvm luks lvm

vg0-swap 9G

vg0-btrfs 100% @ @home @log @nix

"compress-force=zstd:1" "noatime" "discard=async"

TODO switch from 3 to 1

may want to use ftrim instead of discard

## desktop:

/boot FAT32 512M

lvm

vg-swap 38G

vg-btrfs 100% @ @home @log @nix @persist

benchmark zstd -b1

"compress-force=zstd:3" "noatime" check lsblk --discard

autodefrag? 

# TODO:

- test

