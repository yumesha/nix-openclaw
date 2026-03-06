{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "openclaw-app";
  version = "2026.2.13";

  src = fetchzip {
    url = "https://github.com/yumesha/openclaw-v2026.2.16/releases/download/v2026.2.16/OpenClaw-2026.2.16.zip";
    hash = "sha256-ewIZCQ3mg9dus3tD3BdUmESwsk1CFpClbJbLRT1g9Bc=";
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = "${../scripts/openclaw-app-install.sh}";

  meta = with lib; {
    description = "OpenClaw macOS app bundle";
    homepage = "https://github.com/yumesha/openclaw-v2026.2.16";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
