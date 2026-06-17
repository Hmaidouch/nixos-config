{ config, pkgs, ... }:

{
   
    home-manager.users.benattia = {
  
    home.enableNixpkgsReleaseCheck = false;
    home.username = "benattia";
    home.homeDirectory = "/home/benattia";
    home.stateVersion = "26.05";

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

  };

  users.users.benattia = {
    isNormalUser = true;
    description = "Benattia";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  # gdm alternative
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "benattia"; # تأكد من كتابة اسم المستخدم الخاص بك
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
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
  ];

hardware.graphics = {
  enable = true;
  enable32Bit = true;
};

# 2. إخبار النظام بتحميل تعريف نفيديا
services.xserver.videoDrivers = [ "nvidia" ];

nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };
  
hardware.nvidia = {
  # إلزامي جداً لوايلاند وهايبرلاند
  modesetting.enable = true;

  # عطل خيارات الطاقة المتقدمة لأنها تسبب تجمد الكروت القديمة عند الخمول
  powerManagement.enable = false;
  powerManagement.finegrained = false;

  # الكروت القديمة لا تدعم التعريفات مفتوحة المصدر الجديدة من نفيديا
  open = false;

  # تفعيل واجهة التحكم تيرمينال/تطبيق نفيديا
  nvidiaSettings = true;

  # 🔥 السطر السحري: إجبار النظام على استخدام إصدار 470 المتوافق مع كرتك
  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
};

environment.sessionVariables = {
  # إجبار الحزم على استخدام كرت نفيديا عبر خادم GBM
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";

  # سطر الأمان لمنع اختفاء مؤشر الماوس (مشكلة شهيرة في نفيديا)
  WLR_NO_HARDWARE_CURSORS = "1";
  
  # إجبار تطبيقات Qt (مثل فوتوشوب المحاكي أو الواجهات) على استخدام وايلاند
  QT_QPA_PLATFORM = "wayland";
};

}

