{ lib
, stdenv
, papirusYellow
, numix-icon-theme
}:

let
  sizes = [ "16" "16@2x" "22" "22@2x" "24" "24@2x" "32" "32@2x" "48" "48@2x" "64" "64@2x" ];
  sizesStr = lib.concatStringsSep " " sizes;

  # Papirus icon names -> Numix source icon names (without .svg)
  folderOverrides = [
    { papirus = "folder-documents"; numix = "blue-folder-documents"; }
    { papirus = "folder-download";  numix = "blue-folder-download"; }
    { papirus = "folder-downloads"; numix = "blue-folder-download"; }
    { papirus = "folder-music";     numix = "blue-folder-music"; }
    { papirus = "folder-pictures";  numix = "blue-folder-pictures"; }
    { papirus = "folder-picture";   numix = "blue-folder-pictures"; }
    { papirus = "folder-images";    numix = "blue-folder-pictures"; }
    { papirus = "folder-video";     numix = "blue-folder-video"; }
    { papirus = "folder-videos";    numix = "blue-folder-video"; }
  ];
in
stdenv.mkDerivation {
  pname = "papirus-custom-folders";
  inherit (papirusYellow) version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ${papirusYellow}/share/icons/* $out/share/icons/
    chmod -R u+w $out/share/icons/

    for size in ${sizesStr}; do
      srcDir="${numix-icon-theme}/share/icons/Numix/$size/places"
      [ -d "$srcDir" ] || continue

      for theme in Papirus Papirus-Dark Papirus-Light; do
        targetDir="$out/share/icons/$theme/$size/places"
        [ -d "$targetDir" ] || continue

    ${lib.concatMapStringsSep "\n" (o: ''
        # ${o.papirus}
        if [ -f "$srcDir/${o.numix}.svg" ]; then
          cp -f "$srcDir/${o.numix}.svg" "$targetDir/${o.papirus}.svg"
          cp -f "$srcDir/${o.numix}.svg" "$targetDir/yellow-${o.papirus}.svg"
          cp -f "$srcDir/${o.numix}.svg" "$targetDir/yellow-${o.papirus}-open.svg" 2>/dev/null || true
        fi
    '') folderOverrides}

      done
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Papirus icon theme with Numix special folder icons";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
