{ stdenvNoCC, fetchFromGitHub, gtk3, hicolor-icon-theme, kdePackages }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "win11-icon-theme";
  version = "unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Win11-icon-theme";
    rev = "a5b460a407da143b32f19a503d7fcebb3edf2371";
    sha256 = "09sish0afz3m5w68vmbn2rnfj69f78gx3b54fi9m6njjwn84wszq";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ hicolor-icon-theme kdePackages.breeze-icons ];

  dontDropIconThemeCache = true;
  dontWrapQtApps = true;
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    runHook preInstall
    themeDir=$out/share/icons/Win11
    mkdir -p "$themeDir/status"
    cp -r COPYING AUTHORS "$themeDir/"
    cp -r src/index.theme "$themeDir/"
    cp -r src/actions src/animations src/apps src/categories src/devices src/emotes src/emblems src/mimes src/places src/preferences "$themeDir/"
    cp -r src/status/16 src/status/22 src/status/24 src/status/32 src/status/symbolic "$themeDir/status/"
    cp -r links/actions links/apps links/categories links/devices links/emotes links/emblems links/mimes links/places links/preferences links/status "$themeDir/"
    ln -sfn "$themeDir/preferences/32" "$themeDir/preferences/22"
    gtk-update-icon-cache --force "$themeDir"
    runHook postInstall
  '';
})
