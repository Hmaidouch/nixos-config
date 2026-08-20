{ lib
, stdenv
, papirus-icon-theme
, papirus-folders
}:

stdenv.mkDerivation {
  pname = "papirus-yellow";
  inherit (papirus-icon-theme) version;

  src = papirus-icon-theme;

  nativeBuildInputs = [ papirus-folders ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r share/icons/* $out/share/icons/

    # Create a temporary XDG_DATA_HOME structure for papirus-folders
    TMP_DATA=$(mktemp -d)
    mkdir -p "$TMP_DATA/share/icons"
    for theme in Papirus Papirus-Dark Papirus-Light; do
      if [ -d "$out/share/icons/$theme" ]; then
        ln -s "$out/share/icons/$theme" "$TMP_DATA/share/icons/$theme"
        chmod -R u+w "$out/share/icons/$theme"
        XDG_DATA_HOME="$TMP_DATA/share" papirus-folders -C yellow -t "$theme" -o
        rm "$TMP_DATA/share/icons/$theme"
      fi
    done
    rm -rf "$TMP_DATA"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Papirus icon theme with yellow folders";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
