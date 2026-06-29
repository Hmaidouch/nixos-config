{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    xdg.configFile."swaync".source = ./dotfiles;
  };
}



