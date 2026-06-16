{ config, pkgs, ... }:

{

  home-manager.users.benattia = {
  
    home.enableNixpkgsReleaseCheck = false;
    home.username = "benattia";
    home.homeDirectory = "/home/benattia";
    home.stateVersion = "26.05";

    home.file.".config/hypr/hyprland.lua".text = ''
      hl.config({
        input = {
            kb_layout = "fr,ara",
            kb_options = "grp:alt_shift_toggle"
        },

        monitor = {
            "Unknown-1,1920x1080@60,0x0,1"
        }
    })

    hl.bind("SUPER + Q", hl.dsp.window.close())
    hl.bind("SUPER + T", hl.dsp.exec_cmd("alacritty"))
    hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
    hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))
    hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))

    hl.bind(
        "SUPER + mouse:272",
        hl.dsp.window.drag(),
        { mouse = true }
    )

    hl.bind(
        "SUPER + mouse:273",
        hl.dsp.window.resize(),
        { mouse = true }
    )
  '';

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

