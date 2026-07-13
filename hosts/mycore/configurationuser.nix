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
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" "kvm"];
    shell = pkgs.zsh;
  };

  programs.uwsm.enable = true;

  # gdm alternative
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        #command = "start-hyprland";
        command = "niri-session";
        user = "benattia"; # تأكد من كتابة اسم المستخدم الخاص بك
      };
      default_session = {
       # command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      
       # إجبار tuigreet على تمرير أمر UWSM الخاص بـ Niri
       # command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd \"uwsm start -S -s niri.desktop\"";

       
       # command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Niri";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start niri'";

        #command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions /run/current-system/sw/share/wayland-sessions";
        user = "benattia";
      };
    };
  };

  services = {
  # 1. تفعيل خدمة gvfs المسؤول الأساسي في بيئات الـ Gnome/GTK عن قراءة الفلاشات في Nemo
  gvfs.enable = true;

  # 2. تفعيل خدمة udisks2 لإدارة وتجهيز وتفكيك وسائط التخزين تلقائياً
  udisks2.enable = true;

  # 3. تفعيل الـ devmon (اختياري ولكنه ممتاز لعمل Mount تلقائي للفلاشة بمجرد إدخالها)
  devmon.enable = true;
};

  environment.systemPackages = with pkgs; [
    git
    curl
   # pkgs.polkit_gnome
    lm_sensors
tree
    ntfs3g

   waydroid
   android-studio
   android-tools
   wl-clipboard

   networkmanager_dmenu

  # for image explorer
   loupe
   #noctalia-shell
  ];

  # for localsend
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 53317 ];
  allowedUDPPorts = [ 53317 ];
};

# تفعيل خدمة libvirtd لإدارة الآلات الافتراضية
virtualisation.libvirtd.enable = true;

# تفعيل ميزتي Spice و KVM لتسريع الرسوميات والصوت داخل الأنظمة الوهمية
virtualisation.spiceUSBRedirection.enable = true;
programs.virt-manager.enable = true;

virtualisation.waydroid.enable = true;
virtualisation.waydroid.package = pkgs.waydroid-nftables;

programs.xwayland.enable = true;



#for noctalia
#nix.settings = {
 # extra-substituters = [
 #   "https://noctalia.cachix.org"
 # ];

 # extra-trusted-public-keys = [
 #   "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
 # ];
#};
  
}
