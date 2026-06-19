{ config, pkgs, lib, ... }:

{

  home-manager.users.benattia = {

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

  };

}
