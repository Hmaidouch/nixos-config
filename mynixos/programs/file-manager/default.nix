{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
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
      text = ''
        file:///home/benattia/Downloads Downloads
        file:///home/benattia/Documents Documents
        file:///home/benattia/Pictures Pictures
        file:///home/benattia/Videos Videos
        file:///home/benattia/Music Music
        file:///mnt/disk_d disk_d
        file:///mnt/disk_d/mynixos/config3 config3
      '';
    };

    # حجم خط تسميات الأيقونات في عرض الأيقونات
    xdg.configFile."gtk-3.0/gtk.css".text = ''
      .nemo-canvas-item {
        font-size: 10px;
      }
    '';

    dconf = {
      enable = true;
      settings = {
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
