# birdclaw - X/Twitter archive/inbox (TypeScript/pnpm project)
{
  pkgs,
  birdclawSrc,
}:

let
  pnpm = pkgs.pnpm_10;
  version = "0.1.0";
  pname = "birdclaw";

  # Placeholder hash — run `nix build` to get the correct one from the error
  pnpmDeps = pnpm.fetchDeps {
    inherit pname version;
    src = birdclawSrc;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    fetcherVersion = 3;
  };
in
pkgs.stdenv.mkDerivation {
  inherit pname version;
  src = birdclawSrc;

  nativeBuildInputs = [
    pnpm
    pnpm.configHook
    pkgs.nodejs_22
    pkgs.makeWrapper
  ];

  inherit pnpmDeps;

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/birdclaw
    cp -r dist/* $out/lib/birdclaw/
    makeWrapper ${pkgs.nodejs_22}/bin/node $out/bin/birdclaw \
      --add-flags "$out/lib/birdclaw/index.js"
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "X/Twitter archive and inbox tool";
    homepage = "https://github.com/steipete/birdclaw";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "birdclaw";
  };
}
