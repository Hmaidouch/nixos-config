{ config, lib, ... }:

{ 
  
  home-manager.users.benattia = {
    xdg.configFile."rofi".source = ./dotfiles;
  };

}
