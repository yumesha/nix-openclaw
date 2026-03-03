# Pinned OpenClaw source for nix-openclaw
# Using yumesha fork
{
  owner = "yumesha";
  repo = "openclaw";
  # Release v2026.3.3 (clean rebase)
  rev = "v2026.3.3";
  hash = "sha256-lyygwNo9P+ArqiL+k+z+2gXQ2ydiwVj4TFcJmRAQkBo=";
  # To update: run `nix build .#openclaw-gateway` and copy the hash from the error
  pnpmDepsHash = "sha256-QnKPVUPgy3znCQRmfqiIPtRLgZ0SPwWqUsJ4USF2LJE=";
}
