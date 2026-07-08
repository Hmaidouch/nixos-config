1 - nix-shell -p git

2 - sudo git clone https://github.com/Hmaidouch/nixos-config.git

3 - cd nixos-config

4 - sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix

5 - sudo nixos-rebuild switch --flake .#benattia
