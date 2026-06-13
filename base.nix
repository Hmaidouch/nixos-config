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
      #"$mod" = "SUPER";

       hl.on("hyprland.start", function () 
         hl.exec_cmd("firefox") -- Execute waybar, hyprpaper, firefox
       end);

       config.input = {
         kb_layout = "fr,ara";
         kb_options = "grp:alt_shift_toggle";
       };

      config.monitor = [
        #        "eDP-1,1920x1080@59.99,auto,1"
        # ",prefered,auto,1"
        "Unknown-1,1920x1080@60,0x0,1"
      ];

     # hl.bind("SUPER + Q", hl.dsp.exec_cmd("killactive"))
     # hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
     # hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
     # hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))

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
    git
    firefox
    vscode
    alacritty
    nemo
  ];

}

