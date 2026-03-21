# Custom bird package from private repo (TypeScript/Bun project)
{
  pkgs,
  birdSrc,
}:

let
  pnpm = pkgs.pnpm_10;
  version = "0.9.1";
  pname = "bird";

  # Pre-fetch pnpm dependencies (Fixed Output Derivation)
  # Run `nix build` to get the correct hash from the error message
  pnpmDeps = pnpm.fetchDeps {
    inherit pname version;
    src = birdSrc;
    hash = "sha256-3agqrHhNC8kgBZNmcWlUYTue5GbKg8iNGDBt6SkoLM0=";
    fetcherVersion = 3; # pnpm lockfile v9
  };
in
pkgs.stdenv.mkDerivation {
  inherit pname version;
  src = birdSrc;

  nativeBuildInputs = [
    pnpm
    pnpm.configHook
    pkgs.bun
    pkgs.nodejs_22
  ];

  inherit pnpmDeps;

  buildPhase = ''
    runHook preBuild

    # Build TypeScript
    pnpm run build:dist

    # Build standalone binary with bun
    export BIRD_VERSION="${version}"
    export BIRD_GIT_SHA="nixbuild"

    echo "Building bird binary from src/cli.ts..."
    bun build --compile --minify '--env=BIRD_*' src/cli.ts --outfile bird

    # Verify binary was created correctly
    if [ ! -f bird ]; then
      echo "ERROR: bird binary was not created!"
      exit 1
    fi

    echo "Binary size: $(du -h bird)"
    echo "Testing binary..."
    ./bird --version || echo "Warning: version check failed"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bird $out/bin/
    runHook postInstall
  '';

  # Don't strip - bun binaries have embedded JS that gets corrupted
  dontStrip = true;

  meta = with pkgs.lib; {
    description = "Bird - X/Twitter CLI tool (custom build)";
    homepage = "https://github.com/yumesha/bird-x-twitter-cmdline";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
