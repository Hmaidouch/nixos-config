{ config, pkgs, ... }:

{

  home-manager.users.benattia = {

home.file.".local/share/wallpaper" = {
  source = ./scripts;
  recursive = true;
};

      home.packages = with pkgs; [
    awww
    wallust
    waypaper

    #(writeShellScriptBin "wallpaper"
    #  (builtins.readFile ./scripts/wallpaper.sh))
            (writeShellScriptBin "wallpaper" '' exec "$HOME/.local/share/wallpaper/wallpaper.sh" '')

  ];

  home.file.".config/wallust" = {
  source = ./dotfiles;
  recursive = true;
};
  };
}
