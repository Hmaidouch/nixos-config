{ config, pkgs, ... }:

let
  # ثيم أيقونات Windows 11 (مخصص لمدير الملفات فقط، ليس في nixpkgs)
  win11IconTheme = pkgs.callPackage ./win11-icon-theme.nix { };

  bookmarks = ''
    file:///home/benattia/Downloads Downloads
    file:///home/benattia/Documents Documents
    file:///home/benattia/Pictures Pictures
    file:///home/benattia/Videos Videos
    file:///home/benattia/Music Music
    file:///mnt/disk_d disk_d
    file:///mnt/disk_d/mynixos/config3 config3
  '';

  nemoCss = ''
    .nemo-canvas-item {
      font-size: 10px;
    }
  '';

  # دليل GTK الخاص بمدير الملفات فقط
  fmConfigHome = "$HOME/.config/file-manager";

  # غلاف يوجّه XDG_CONFIG_HOME إلى fmConfigHome كي تقرأه nemo/thunar
  # فقط (Win11) بينما بقية التطبيقات تستخدم الثيم العام.
  makeFmWrapper = name: pkg: pkgs.symlinkJoin {
    name = name;
    paths = [ pkg ];
    postBuild = ''
      rm -f $out/bin/${name}
      cat > $out/bin/${name} <<'EOF'
#!/bin/sh
OV="$HOME/.config/file-manager"
mkdir -p "$OV/gtk-3.0"
# ربط بقية إعدادات ~/.config كي لا تنكسر التطبيقات المفتوحة من المدير
for d in "$HOME"/.config/*; do
  [ -e "$d" ] || continue
  base="$(basename "$d")"
  [ "$base" = "gtk-3.0" ] && continue
  [ "$base" = "file-manager" ] && continue
  if [ -L "$OV/$base" ] && [ ! -e "$OV/$base" ]; then
    ln -sfn "$d" "$OV/$base"
  elif [ ! -e "$OV/$base" ]; then
    ln -s "$d" "$OV/$base"
  fi
done
export XDG_CONFIG_HOME="$OV"
exec ${pkg}/bin/${name} "$@"
EOF
      chmod +x $out/bin/${name}
    '';
  };

  nemo = makeFmWrapper "nemo" pkgs.nemo;
  thunar = makeFmWrapper "thunar" pkgs.thunar;
in
{
  home-manager.users.benattia = {
    home.packages = [
      win11IconTheme
      nemo
      thunar
      pkgs.nemo-fileroller
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "nemo.desktop";
        "text/plain" = [ "org.gnome.TextEditor.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
      };
      associations.added = {
        "text/plain" = [ "code.desktop" "org.gnome.TextEditor.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
      };
    };
    xdg.configFile."mimeapps.list".force = true;

    # ينشئ المجلدات القياسية المفقودة (Documents, Music, ...)
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };

    # مجلدات الشريط الجانبي (كل سطر: مسار ثم تسمية)
    xdg.configFile."gtk-3.0/bookmarks" = {
      force = true;
      text = bookmarks;
    };

    # حجم خط تسميات الأيقونات في عرض الأيقونات
    xdg.configFile."gtk-3.0/gtk.css".text = nemoCss;

    # إعدادات GTK المخصصة لمدير الملفات فقط (Win11)
    home.file = {
      ".config/file-manager/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-icon-theme-name=Win11
        gtk-theme-name=Orchis-Light
      '';
      ".config/file-manager/gtk-3.0/bookmarks".text = bookmarks;
      ".config/file-manager/gtk-3.0/gtk.css".text = nemoCss;
    };

    dconf = {
      enable = true;
      settings = {
        "org.gnome.desktop.interface" = {
          "icon-theme" = "Tela-circle-light";
          "gtk-theme" = "Orchis-Light";
        };
        "org.nemo.preferences" = {
          "click-policy" = "double";
          "show-hidden-files" = true;
          "show-full-path-titles" = true;
          "confirm-trash" = true;
          "sort-directories-first" = true;
          "default-sort-order" = "name";
          "default-folder-viewer" = "list-view";
          "date-format" = "locale";
        };
        "org.nemo.window-state" = {
          "start-with-toolbar" = true;
          "start-with-location-bar" = true;
          "start-with-status-bar" = true;
          "start-with-sidebar" = true;
          "start-with-menu-bar" = true;
          "side-pane-view" = "places";
        };
        "org.nemo.list-view" = {
          "default-visible-columns" = [ "name" "size" "type" "date_modified" ];
          "default-column-order" = [ "name" "size" "type" "date_modified" ];
        };
      };
    };
  };
}
