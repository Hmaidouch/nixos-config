{ config, pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;
    hinting.enable = true;
    subpixel.rgba = "rgb";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    jetbrains-mono # تم إضافته هنا ليعمل خط الـ Monospace
    corefonts      # يوفر Times New Roman
    vista-fonts    # تم إضافته هنا ليوفر Segoe UI

    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    serif = [ "Times New Roman" ];
    sansSerif = [ "Segoe UI" ];
    monospace = [ "JetBrains Mono" ];
  };

}