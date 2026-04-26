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
    pkgs.python3  # required for node-gyp (better-sqlite3 native build)
  ];

  inherit pnpmDeps;

  # birdclaw hardcodes ~/Projects/bird/bird as the bird companion tool path.
  # Patch it to just "bird" so it resolves from PATH (where nix puts it).
  postPatch = ''
    sed -i 's|path.join(os.homedir(), "Projects", "bird", "bird")|"bird"|g' src/lib/config.ts
  '';

  # pnpm.configHook installs JS deps during configure, but better-sqlite3's
  # install script (prebuild-install || node-gyp rebuild) may silently fail.
  # prebuild-install has no network in sandbox; node-gyp needs Python and
  # local Node.js headers (npm_config_nodedir) because it can't download them.
  buildPhase = ''
    runHook preBuild
    export npm_config_nodedir="${pkgs.nodejs_22}"
    pnpm rebuild better-sqlite3
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install node_modules for production
    mkdir -p $out/lib/birdclaw
    cp -r . $out/lib/birdclaw/

    # Create wrapper script that runs CLI from source
    mkdir -p $out/bin
    # birdclaw stores its database in ~/.birdclaw/ and looks for the
    # 'bird' companion tool at ~/Projects/bird/bird by default. Don't
    # override HOME — let it use the caller's real home directory.
    makeWrapper ${pkgs.tsx}/bin/tsx $out/bin/birdclaw \
      --add-flags "--tsconfig $out/lib/birdclaw/tsconfig.json" \
      --add-flags "$out/lib/birdclaw/src/cli.ts"

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
