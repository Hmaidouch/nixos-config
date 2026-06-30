{ config, pkgs, ... }:

{

  home-manager.users.benattia = {
    
    xdg.configFile."waybar".source = ./dotfiles;
    home.file.".local/share/news".source = ../../scripts/news;

    programs.waybar = {
      enable = true;
      systemd.enable = false;
    };
  };
}
