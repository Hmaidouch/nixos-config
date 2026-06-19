{ config, pkgs, lib, ... }:

{
  
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  home-manager.users.benattia = {

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

  };



}
