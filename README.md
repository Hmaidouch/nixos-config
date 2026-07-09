Installation
# Enter a shell with git
nix-shell -p git

# Clone the repository
git clone https://github.com/Hmaidouch/nixos-config.git

cd nixos-config

# Copy your local hardware configuration into the repo
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix

# Apply the system configuration
sudo nixos-rebuild switch --flake .#benattia
