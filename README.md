# 1) ادخل إلى شل فيه git
nix-shell -p git

# 2) انسخ الريبو
git clone https://github.com/Hmaidouch/nixos-config.git
cd nixos-config

# 3) انسخ ملف العتاد المحلي إلى مكانه داخل المشروع
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix

# 4) طبّق النظام من flake
sudo nixos-rebuild switch --flake .#benattia
