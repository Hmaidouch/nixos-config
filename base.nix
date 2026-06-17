{ config, pkgs, ... }:

{
#gvfg
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

}

