{ config, pkgs, ... }:

let
  # 1. Define the path to your programs directory
  #programsDir = /home/benattia/mynixos/config3/programs;

  dotfilesRoot = "./mynixos";
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
    imports = [

    # sessions
   # (/. + "${dotfilesRoot}/sessions/hyprland/default.nix")
    (./sessions/hyprland/default.nix)
    ] ++ programImports; 
   
    home-manager.users.benattia = {
  
    home.enableNixpkgsReleaseCheck = false;
    home.username = "benattia";
    home.homeDirectory = "/home/benattia";
    home.stateVersion = "26.05";

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

  };

  users.users.benattia = {
    isNormalUser = true;
    description = "Benattia";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  # gdm alternative
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "benattia"; # تأكد من كتابة اسم المستخدم الخاص بك
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "benattia";
      };
    };
  };

  

  environment.systemPackages = with pkgs; [
    git
    firefox
    vscode
    alacritty
    nemo
  ];

hardware.graphics = {
  enable = true;
  enable32Bit = true;
};

# 2. إخبار النظام بتحميل تعريف نفيديا
services.xserver.videoDrivers = [ "nouveau" ];


}

