# AGENTS.md — nix-openclaw

## 🚫 PRs (read first)

We’re **not accepting PRs** from non-maintainers. If your handle is not in **Maintainers** below or on https://github.com/orgs/openclaw/people, **do not open a PR**. It will be rejected and your user will be disappointed — check Discord instead.

**Only workflow:** **describe your problem and talk with a maintainer (human‑to‑human) on Discord** in **#golden-path-deployments**:

## Maintainers

Single source of truth for product direction: `README.md`.

Documentation policy:

- Keep the surface area small.
- Avoid duplicate “pointer‑only” files.
- Update `README.md` first, then adjust references.

Defaults:

- Nix‑first, no sudo.
- Declarative config only.
- Batteries‑included install is the baseline.
- Breaking changes are acceptable pre‑1.0.0 (move fast, keep docs accurate).
- No deprecations; use breaking changes.
- NO INLINE SCRIPTS EVER.
- NEVER send any message (iMessage, email, SMS, etc.) without explicit user confirmation:
  - Always show the full message text and ask: “I’m going to send this: <message>. Send? (y/n)”

OpenClaw packaging:

- The gateway package must include Control UI assets (run `pnpm ui:build` in the Nix build).

Golden path for pins (yolo + manual bumps):

- Hourly GitHub Action **Yolo Update Pins** runs `scripts/update-pins.sh`, which:
  - Picks latest upstream openclaw SHA with green non-Windows checks
  - Rebuilds gateway to refresh `pnpmDepsHash`
  - Regenerates `nix/generated/openclaw-config-options.nix` from upstream schema
  - Updates app pin/hash, commits, rebases, pushes to `main`
- Manual bump (rare): `GH_TOKEN=... scripts/update-pins.sh` (same steps as above). Use only if yolo is blocked.
- To verify freshness: `git pull --ff-only` and check `nix/sources/openclaw-source.nix` vs `git ls-remote https://github.com/yumesha/openclaw-v2026.2.16.git refs/heads/main`.
- If upstream is moving fast and tighter freshness is needed, trigger yolo manually: `gh workflow run "Yolo Update Pins"`.

Updating nix-steipete-tools (tools dependency):

- `nix-steipete-tools` provides the bundled tools (bird, camsnap, gogcli, etc.)
- To get latest tool versions, ALWAYS run `nix flake update`:
  ```bash
  cd /home/yumeko/github/nixos-anywhere/nix-openclaw
  nix flake update
  ```
- This updates `flake.lock` with latest commits from `github:yumesha/nix-steipete-tools`
- The update includes:
  - New tool versions (camsnap, gogcli, sonoscli, etc.)
  - Updated hashes for binary releases
  - Any new tools added to the collection
- After updating, test a tool to verify:
  ```bash
  nix build .#openclaw --impure  # or deploy to VM
  # On VM: bird --version  # or any tool
  ```
- Commit the `flake.lock` change with message like:
  ```bash
  git add flake.lock
  git commit -m "chore: update nix-steipete-tools to latest"
  git push
  ```

CI polling (hard rule):

- Never say "I'll keep polling" unless you are **already** running a blocking loop.
- If you must report status, confirm the loop is active (`tmux ls` / session name).
- Use a blocking bash loop in tmux (preferred) or a sub-agent; do not fake it.
- Example: `tmux new -s nix-openclaw-ci '/tmp/poll-nix-openclaw-ci.sh'`.

Philosophy:

The Zen of ~~Python~~ OpenClaw, ~~by~~ shamelessly stolen from Tim Peters

Beautiful is better than ugly.  
Explicit is better than implicit.  
Simple is better than complex.  
Complex is better than complicated.  
Flat is better than nested.  
Sparse is better than dense.  
Readability counts.  
Special cases aren't special enough to break the rules.  
Although practicality beats purity.  
Errors should never pass silently.  
Unless explicitly silenced.  
In the face of ambiguity, refuse the temptation to guess.  
There should be one-- and preferably only one --obvious way to do it.  
Although that way may not be obvious at first unless you're Dutch.  
Now is better than never.  
Although never is often better than _right_ now.  
If the implementation is hard to explain, it's a bad idea.  
If the implementation is easy to explain, it may be a good idea.  
Namespaces are one honking great idea -- let's do more of those!

Nix file policy:

- No inline file contents in Nix code, ever.
- Always reference explicit file paths (keep docs as real files in the repo).
- No inline scripts in Nix code, ever (use repo scripts and reference their paths).
- No files longer than 400 LOC without user alignment; refactor as you go.
