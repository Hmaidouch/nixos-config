{ config, pkgs, ... }:

let
  # 1. Define the path to your programs directory
  #programsDir = /home/benattia/mynixos/config3/programs;

  #dotfilesRoot = "./mynixos";
  programsDir = ./programs;
  #programsDir = /. + "${dotfilesRoot}/programs";

  # 2. Get the content of the directory
  files = builtins.readDir programsDir;

  # 3. Filter for directories only (ignoring regular files like .DS_Store or READMEs)
  directories = builtins.filter 
    (name: files.${name} == "directory") 
    (builtins.attrNames files);

  # 4. Map the directory names to import paths (e.g., ./config/programs/zsh)
  #    Nix automatically looks for default.nix inside these folders.
  programImports = map (name: programsDir + "/${name}") directories;
in
{
  #  imports = [
  #    (./sessions/hyprland/default.nix)
  #  ] ++ programImports; 
    imports = [
      ./sessions/niri/default.nix
      ./sessions/hyprland/default.nix
    ] ++ programImports;

    home-manager.users.benattia = {
  
    home.enableNixpkgsReleaseCheck = false;
    home.username = "benattia";
    home.homeDirectory = "/home/benattia";
    home.stateVersion = "26.05";

    home.packages = [
      pkgs.rofi
      (pkgs.writeShellScriptBin "rofi_show" (builtins.readFile ./scripts/rofi_show.sh))
      (pkgs.writeShellScriptBin "control_menu" (builtins.readFile ./scripts/control_menu.sh))
      (pkgs.writeShellScriptBin "salat" (builtins.readFile ./scripts/salat.sh))
    ];

# أو باستخدام الموديول الجاهز لـ Home Manager (وهو الأجمل):
    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Light";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Tela-circle-light";
        package = pkgs.tela-circle-icon-theme;
      };
    };
  };
 

}

