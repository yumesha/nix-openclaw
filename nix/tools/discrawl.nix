# discrawl - Discord server data mirroring to SQLite (Go project)
{
  pkgs,
  discrawlSrc,
}:

pkgs.buildGoModule {
  pname = "discrawl";
  version = "0.2.0";
  src = discrawlSrc;

  vendorHash = "sha256-bgi0gR9b2bwGahxTz/h6L+ozc+7SmIYlTiH+/pwig3w=";

  # Build the CLI binary
  subPackages = [ "cmd/discrawl" ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    sqlite
  ];

  # Patch go.mod to lower Go version requirement (nixpkgs has 1.25.7, discrawl wants 1.26.1)
  postPatch = ''
    sed -i 's/go 1.26.1/go 1.25/' go.mod
    sed -i 's/go 1.26/go 1.25/' go.mod
  '';

  # CGO is needed for SQLite
  env.CGO_ENABLED = "1";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=0.2.0"
    "-X main.commit=nixbuild"
  ];

  meta = with pkgs.lib; {
    description = "Discord server data mirroring to SQLite for offline search";
    homepage = "https://github.com/yumesha/discrawl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "discrawl";
  };
}
