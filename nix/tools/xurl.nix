{ pkgs, xurlSrc }:
pkgs.buildGoModule {
  pname = "xurl";
  version = "0.1.0";
  src = xurlSrc;
  vendorHash = "sha256-sYGm/Yrcu+i+EsjcJfZcCrp3tvWLxo8cte5YnC0fEbI=";
  meta.mainProgram = "xurl";
}
