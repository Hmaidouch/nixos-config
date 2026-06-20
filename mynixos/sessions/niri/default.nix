{ config, pkgs, lib, ... }:

{
  
  # 1. تفعيل نيري
  programs.niri.enable = true;

  # 2. تفعيل UWSM بشكل صريح (تأكد أنه لم يكن مفعلاً داخل ملف hyprland فقط)
  #programs.uwsm.enable = true;

  # 3. تعويض الـ Portals المفقودة بعد حذف هايبرلاند
  #xdg.portal = {
  #  enable = true;
   # wlr.enable = true; # لضمان توافقية نيري مع مشاركة الشاشة والاختصارات
   # extraPortals = [ 
   #   pkgs.xdg-desktop-portal-gnome
   #   pkgs.xdg-desktop-portal-gtk 
   # ];
   # config.common.default = [ "gnome" "gtk" ];
  #};

  home-manager.users.benattia = {

    xdg.configFile."niri/config.kdl".source = ./config.kdl;

  };

}
