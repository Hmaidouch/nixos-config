{ config, pkgs, ... }:

{

  home-manager.users.benattia = {
    
    xdg.configFile."waybar".source = ./dotfiles;

    programs.waybar = {
      enable = true;
      systemd.enable = false;
    };
  };
}
