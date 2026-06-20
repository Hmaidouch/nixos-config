{ config, pkgs, ... }:

{
  # إعدادات Nix لتسهيل التطوير والاختبار
  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };

  users.users.benattia = {
    isNormalUser = true;
    description = "Benattia";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };


  # gdm alternative
  services.greetd = {
    enable = true;
    settings = {
     # initial_session = {
      #  command = "start-hyprland";
     #   user = "benattia"; # تأكد من كتابة اسم المستخدم الخاص بك
     # };
      default_session = {
       # command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
       command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions /run/current-system/sw/share/wayland-sessions";
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
    unzip
    posy-cursors

    #swaynotificationcenter
    
  ];

}