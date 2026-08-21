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
  '';

  # خصائص العرض العامة لـ dolphin (تُقرأ من viewprops عند تفعيل GlobalViewProps)
  # يجب أن يطابق اسم المجلد قيمة ViewPropsTimestamp في dolphinrc
  viewPropsTimestamp = "2026,8,21,0,0,0";

  dolphinGlobalViewProps = ''
    [Dolphin]
    Version=2
    ViewMode=2
    HiddenFilesShown=true
    SortFoldersFirst=true
    VisibleRoles=Details_name,Details_size,Details_type,Details_modificationtime
  '';
in
{
  home-manager.users.benattia = {

    # xdg.configFile."mimeapps.list".source = ./mimeapps.list;

    home.packages = [
      win11IconTheme

      # دعم الضغط والفك داخل dolphin
      pkgs.kdePackages.ark
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.kde.dolphin.desktop";
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

    # أيقونات Win11 لتطبيقات Qt/KDE (dolphin)
    xdg.configFile."kdeglobals".text = ''
      [Icons]
      Theme=Win11
    '';

    # إعدادات dolphin
    xdg.configFile."dolphinrc" = {
      force = true;
      text = ''
        [General]
        GlobalViewProps=true
        ShowFullPath=true
        ShowFullPathInTitleBar=true
        ViewPropsTimestamp=${viewPropsTimestamp}
      '';
    };

    # خصائص العرض الافتراضية: عرض القائمة، الملفات المخفية، المجلدات أولاً
    xdg.dataFile."dolphin/viewprops/${viewPropsTimestamp}/.directory" = {
      force = true;
      text = dolphinGlobalViewProps;
    };
  };
}
