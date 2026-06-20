{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    #autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    interactiveShellInit = ''
      # منع تكرار الأوامر في التاريخ
      setopt HIST_IGNORE_ALL_DUPS

      # الانتقال للمجلد وعرض محتوياته تلقائياً
      cd() {
        builtin cd "$@" && ls
      }

      # حفظ الصور من الحافظة مباشرة (Wayland)
      pasteimg() {
          local name="''${1:-clipboard.png}"
          [[ "$name" != *.png ]] && name="$name.png"
          wl-paste --type image/png | sudo tee "$name" > /dev/null
      }
    '';


    shellAliases = {
      stop = "shutdown now";
      out = "loginctl terminate-user benattia";
      nrs = "sudo nixos-rebuild switch --flake .#benattia";
      nc = "sudo nix-collect-garbage -d";
      mntd = "sudo mount /dev/sda1 /mnt/disk_d";
      cc = "clear";

      cdn = "cd ~/nixos-config";
    };
    
    
    ohMyZsh = {
        enable = true;
        plugins = [
          "git"                
        ];
        theme = "robbyrussell";
      };
    };



}



