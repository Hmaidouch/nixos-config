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
      python3
      util-linux

      (pkgs.writeShellScriptBin "linux-updates" ''
        exec "${linuxUpdatesPkg}/share/linux-updates/linux_updates.sh" "$@"
      '')
    ];

    systemd.user.services.linux-updates = {
      Unit = {
        Description = "Linux updates Telegram notifier";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        EnvironmentFile = "%h/nixos-config/.env";
        ExecStart = "${linuxUpdatesPkg}/share/linux-updates/linux_updates.sh";
      };
    };

    systemd.user.timers.linux-updates = {
      Unit = {
        Description = "Run linux-updates periodically";
      };

      Timer = {
        OnUnitActiveSec = "6h";
        Persistent = true;
        Unit = "linux-updates.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

  };
}