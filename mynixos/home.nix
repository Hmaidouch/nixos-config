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

    home.packages = with pkgs; [
      rofi
      (writeShellScriptBin "rofi_show" (builtins.readFile ./scripts/rofi_show.sh))
      (writeShellScriptBin "control_menu" (builtins.readFile ./scripts/control_menu.sh))
      (writeShellScriptBin "salat" (builtins.readFile ./scripts/salat.sh))
      (writeShellScriptBin "theme_switch" (builtins.readFile ./scripts/themes/theme_switch.sh))
      (writeShellScriptBin "iconstheme_switch" (builtins.readFile ./scripts/themes/iconstheme_switch.sh))
      #news :
      (writeShellScriptBin "niri_news" (builtins.readFile ./scripts/news/niri_news.sh))
      (writeShellScriptBin "hyprland_news" (builtins.readFile ./scripts/news/hyprland_news.sh))
      (writeShellScriptBin "nixos_news" (builtins.readFile ./scripts/news/nixos_news.sh))
      (writeShellScriptBin "kmp_news" (builtins.readFile ./scripts/news/kmp_news.sh))

      firefox
      vscode
      alacritty
      nemo
      posy-cursors
      swaylock-effects
      swaynotificationcenter
      jq

      glib

      libnotify
  # تأكد أيضاً من وجود الأداوت الأخرى التي يستخدمها السكريبت:
  zenity
  wl-clipboard # لأمر wl-copy
  coreutils    # لأمر fold
   # ---- باقة الثيمات التي تريد تجريبها ----
      matcha-gtk-theme        # ثيم Matcha (الموجود في سكريبتك)
      tokyonight-gtk-theme    # ثيم طوكيو نايت الشهير
      catppuccin-gtk          # ثيم Catppuccin الأنيق (متناسق مع Hyprland جداً)
      gruvbox-gtk-theme       # ثيم جروف بوكس الدافئ
      arc-theme               # ثيم Arc الكلاسيكي الخفيف
    
      # حزمة تابعة لأيقوناتك المفضلة لتكتمل التجربة
      tela-circle-icon-theme

      gnome-text-editor

      # extract zip
      unzip
      file-roller
      nemo-fileroller
      # لتغطية معظم الصيغ المضغوطة
      zip
      p7zip
      gnutar
      gzip
      bzip2
      xz

      galculator
      hyprpicker

      # مستعرض نيمو
  #nemo-with-extensions 
  
  # حزمة أدوات للتحكم اليدوي ومراقبة الأقراص الرسومية (ممتازة مع Nemo)
  gnome-disk-utility

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
        #name = "breeze";
        #package = pkgs.tela-circle-icon-theme;
      };
    };

    services.swaync.enable = true;
  };
 

}

