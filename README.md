nix-shell -p git

git clone https://github.com/Hmaidouch/nixos-config.git

cd nixos-config

sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix

sudo nixos-rebuild switch --flake .#benattia
