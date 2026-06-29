{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    xdg.configFile."matugen".source = ./dotfiles;
  };
}



