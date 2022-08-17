# My [NixOS](https://nixos.org) config

# TODO:

- move more packages from system.environmentPackages to home
- man generate caches?
- try out home-manager standalone
- move to codeberg?

# Filesystem setup:

## laptop:

/boot FAT32 512M

/dev/mapper/cryptlvm luks lvm

vg0-swap 9G

vg0-btrfs 100% @ @home @log @nix

"compress-force=zstd:1" "noatime" "discard=async"

TODO check ssd write/read speed

may want to use ftrim instead of discard

## desktop:

/efi FAT32 512M

lvm

vg-swap 38G

vg-btrfs 100% @ @home @log @nix @persist

benchmark zstd -b1

"compress-force=zstd:3" "noatime"

autodefrag? 
