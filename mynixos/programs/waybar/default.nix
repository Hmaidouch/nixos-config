{ config, pkgs, ... }:

{

  programs.waybar.enable = true;

  home-manager.users.benattia = {
    xdg.configFile."waybar".source = ./dotfiles;
  };
}