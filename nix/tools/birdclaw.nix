# birdclaw - X/Twitter archive/inbox (TypeScript/pnpm project)
# Note: This is a web app + CLI hybrid. The CLI runs from source via tsx.
{
  pkgs,
  birdclawSrc,
}:

let
  pnpm = pkgs.pnpm_10;
  version = "0.1.0";
  pname = "birdclaw";

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version;
    src = birdclawSrc;
    hash = "sha256-YBHLdr9da6LhIawMdv4oofMAFmQ/v1I11EtJcJ2KRys=";
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

  # Don't build — the CLI runs from TypeScript source via tsx
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Install node_modules for production
    mkdir -p $out/lib/birdclaw
    cp -r . $out/lib/birdclaw/

    # Create wrapper script that runs CLI from source
    mkdir -p $out/bin
    makeWrapper ${pkgs.tsx}/bin/tsx $out/bin/birdclaw \
      --run "cd '$out/lib/birdclaw'" \
      --add-flags "src/cli.ts" \
      --set "HOME" "/tmp/birdclaw-home"

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
