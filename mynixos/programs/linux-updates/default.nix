{ config, pkgs, ... }:

let
  linuxUpdatesPkg = pkgs.stdenvNoCC.mkDerivation {
    pname = "linux-updates";
    version = "1.0";

    src = ./scripts/linux-updates;

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/linux-updates
      cp -r ./* $out/share/linux-updates/
      chmod +x $out/share/linux-updates/linux_updates.sh
      find $out/share/linux-updates -type f -name "*.sh" -exec chmod +x {} \;
    '';
  };
in
{
  home-manager.users.benattia = {
    home.packages = with pkgs; [
      curl
      jq
      libxml2

      (pkgs.writeShellScriptBin "linux-updates" ''
        exec "${linuxUpdatesPkg}/share/linux-updates/linux_updates.sh" "$@"
      '')
    ];
  };
}