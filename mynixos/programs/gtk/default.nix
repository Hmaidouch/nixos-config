{ config, pkgs, lib, ... }:
#let

  #themeStateFile = "/home/benattia/.cache/themes/state";
  
  #currentTheme = lib.strings.trim (builtins.readFile themeStateFile);

#in
{
  #imports = [
  #  ./style/style.nix
  #];
  gtk = {
    enable = true;

    theme = {
      name = "Matcha-light-sea";
     # name = currentTheme;
    };

    iconTheme = {
      name = "Tela-yellow";
    };

    #cursorTheme = {
    #  name = "Posy_Cursor";
    #  size = 20;
    #};

    font = {
      name = "Segoe UI"; # خط Windows
      size = 10;
      #      package = pkgs.corefonts;
    };

  
    gtk3 = {
      extraConfig = {
        #gtk-application-prefer-dark-theme=1;
      };
  
    };
    gtk4 = {
      extraConfig = {
        #gtk-application-prefer-dark-theme=1;
      };
  
    };
  };


}



