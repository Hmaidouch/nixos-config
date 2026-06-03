{ config, pkgs, ... }:

{
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

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      ce = "sudo nano /etc/nixos/configuration.nix";
    };

    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font.normal = {
        family = "Ubuntu Mono";
        style = "Regular";
      };
      font.size = 17;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    vscode
    hyprland
    alacritty
  ];

}

