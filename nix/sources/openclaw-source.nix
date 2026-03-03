# Pinned OpenClaw source for nix-openclaw
# Using yumesha fork
{
  owner = "yumesha";
  repo = "openclaw";
  # Release v2026.3.3
  rev = "v2026.3.3";
  hash = "sha256-7nW85hvTjikBV2wVafZ8U7cvKzm+gTDZBTP/s68ZQDI=";
  # To update: run `nix build .#openclaw-gateway` and copy the hash from the error
  pnpmDepsHash = "sha256-QnKPVUPgy3znCQRmfqiIPtRLgZ0SPwWqUsJ4USF2LJE=";
}
