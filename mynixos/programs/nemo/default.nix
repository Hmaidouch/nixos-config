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
