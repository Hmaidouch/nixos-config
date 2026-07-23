{ config, pkgs, inputs, ... }:

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

   # imports = [
   #   inputs.noctalia.homeModules.default
   # ];
   # programs.noctalia-shell.enable = true;

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
      (writeShellScriptBin "network_menu" (builtins.readFile ./scripts/network_menu.sh))

      #Transcribe :
      (writeShellScriptBin "transcribe_groq" (builtins.readFile ./scripts/transcribe/transcribe_groq.sh))
      (writeShellScriptBin "translate" (builtins.readFile ./scripts/transcribe/translate.sh))
      (writeShellScriptBin "merge_subtitle" (builtins.readFile ./scripts/transcribe/merge_subtitle.sh))
      
      #news :
     # (writeShellScriptBin "hyprland_news" (builtins.readFile ./scripts/news/hyprland_news.sh))
      (writeShellScriptBin "hyprland_news" '' exec "$HOME/.local/share/news/hyprland_news.sh" '')
      (writeShellScriptBin "niri_news" '' exec "$HOME/.local/share/news/niri_news.sh" '')
      (writeShellScriptBin "nixos_news" '' exec "$HOME/.local/share/news/nixos_news.sh" '')
      (writeShellScriptBin "kmp_news" '' exec "$HOME/.local/share/news/kmp_news.sh" '')

      firefox
      vscode
      alacritty
      nemo
      posy-cursors
      swaylock-effects
      swaynotificationcenter
      
      jq
      libxml2

      localsend

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
      orchis-theme
      
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


      vlc
      mpv
      opencode
      virt-manager


    ];

# أو باستخدام الموديول الجاهز لـ Home Manager (وهو الأجمل):
    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Light";
        #package = pkgs.orchis-theme;
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

