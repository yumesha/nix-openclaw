# discrawl - Discord server data mirroring to SQLite (Go project)
{
  pkgs,
  discrawlSrc,
}:

pkgs.buildGoModule {
  pname = "discrawl";
  version = "0.2.0";
  src = discrawlSrc;

  vendorHash = "sha256-RBTOknJVteiH7yXdmLzSWYHBAHnTHg9sg8XuQuk6iUE=";

  # Build the CLI binary
  subPackages = [ "cmd/discrawl" ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    sqlite
  ];

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
