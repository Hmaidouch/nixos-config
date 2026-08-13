{ config, pkgs, ... }:

{
  home-manager.users.benattia = {
    programs.firefox = {
      enable = true;

      # يتبنى البروفايل الموجود مسبقاً للحفاظ على بياناته
      profiles.default = {
        id = 0;
        path = "tagudfjt.default";
        storeId = "305c9bb5";

        settings = {
          # ---- الخطوط: Segoe UI للكل ----
          "font.default.x-western" = "sans-serif";
          "font.name.sans-serif.x-western" = "Segoe UI";
          "font.name.serif.x-western" = "Segoe UI";
          "font.name.monospace.x-western" = "Segoe UI";
          "font.name-list.sans-serif.x-western" = "Segoe UI, Noto Sans";
          "font.name-list.serif.x-western" = "Segoe UI, Noto Serif";
          "font.name-list.monospace.x-western" = "Segoe UI, JetBrains Mono";

          # دعم العربية (vista-fonts لا يحتوي Segoe UI عربياً)
          "font.name.sans-serif.x-arabic" = "Noto Sans Arabic";
          "font.name-list.sans-serif.x-arabic" = "Segoe UI, Noto Sans Arabic";

          # ---- الأحجام ----
          "font.size.variable.x-western" = 16;
          "font.size.fixed.x-western" = 14;
          "font.minimum-size.x-western" = 12;

          # ---- المظهر الفاتح المتناسق مع Orchis-Light ----
          "ui.systemUsesDarkTheme" = 0;
          "browser.theme.toolbar-theme" = "light";
          "browser.theme.content-theme" = "light";
          "browser.display.use_system_colors" = true;

          # ---- واجهة مدمجة ----
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "browser.tabs.drawInTitlebar" = true;
        };

        userChrome = ./dotfiles/userChrome.css;
        userContent = ./dotfiles/userContent.css;
      };
    };
  };
}
