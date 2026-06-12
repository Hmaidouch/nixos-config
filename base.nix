{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
  # overlay لإضافة الحزم من unstable
 # unstable = import <unstable> {
 #   config.allowUnfree = true;
 # };

in
{
  imports =
  [
    ( import "${home-manager}/nixos" )
      #"${home-manager}/nixos"
  ];

  home-manager.users.benattia = {
  
    home.enableNixpkgsReleaseCheck = false;
    home.username = "benattia";
    home.homeDirectory = "/home/benattia";
    home.stateVersion = "26.05";

    wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

       input = {
         kb_layout = "fr,ara";
         kb_options = "grp:alt_shift_toggle";
       };

       misc = {
        vfr = true; # (Variable Frame Rate) مهم جداً لتقليل استهلاك الموارد وسلاسة العرض
             force_default_wallpaper = 0; # تعطيل خلفية الفتاة والقطة تماماً
      };

      monitor = [
        #        "eDP-1,1920x1080@59.99,auto,1"
        # ",prefered,auto,1"
        "Unknown-1,1920x1080@60,0x0,1"
      ];

      bind = [
        "$mod, Q, killactive"
        "$mod, T, exec, alacritty"
        "$mod, B, exec, firefox"
        "$mod, E, exec, nemo"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

    };

  };

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
        command = "Hyprland";
        user = "benattia"; # تأكد من كتابة اسم المستخدم الخاص بك
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "benattia";
      };
    };
  };

  

  environment.systemPackages = with pkgs; [
    firefox
    vscode
    alacritty
    nemo
  ];

}

