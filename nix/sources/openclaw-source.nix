# Pinned OpenClaw source for nix-openclaw
# Using yumesha fork with OAuth auto-refresh + OPENCLAW_SKIP_CLAUDE_CLI_SYNC
{
  owner = "yumesha";
  repo = "openclaw";
  # Release v2026.2.16: /startbot /stopbot commands + anti-scanner security
  rev = "v2026.2.16";
  hash = "sha256-9mwyX9YFA5kKPlKaVhCWBHWvUHhTiLpVWPYEzI56kyY=";
  # To update: run `nix build .#openclaw-gateway` and copy the hash from the error
  pnpmDepsHash = "sha256-g2O2p5x5KkgqTbROwRe0BoDE2GMkm0kJs5aqck5cUhw=";
}
