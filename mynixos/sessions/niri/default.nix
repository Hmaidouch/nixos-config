{ config, pkgs, lib, ... }:

{
  
  programs.niri = {
    enable = true;
  };

  home-manager.users.benattia = {

    #xdg.configFile."niri/niri.conf".source = ./niri.conf;
    xdg.configFile."niri/config.kdl".source = ./config.kdl;

  };

}
