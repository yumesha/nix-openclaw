# wacrawl - WhatsApp Desktop archive (Go project)
{
  pkgs,
  wacrawlSrc,
}:

pkgs.buildGoModule {
  pname = "wacrawl";
  version = "0.1.0";
  src = wacrawlSrc;

  # Placeholder hash — run `nix build` to get the correct one from the error
  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  # Build the CLI binary
  subPackages = [ "cmd/wacrawl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=0.1.0"
    "-X main.commit=nixbuild"
  ];

  meta = with pkgs.lib; {
    description = "WhatsApp Desktop archive tool";
    homepage = "https://github.com/yumesha/wacrawl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "wacrawl";
  };
}
