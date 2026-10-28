# AGENTS.md: dotfiles

chezmoi-managed shell environment for the fleet: MacBook (zsh) plus June,
Hetzner, Hetzner VPS and Optiplex (bash). Human-facing overview in
[README.md](README.md); this file is the rules and gotchas.

## Git

- Remote: **public** `github.com/Kounex/dotfiles`, branch `main`. Commit and
  push each finished change. Public means: no secrets, no IPs, no private
  service URLs. Hostnames and ssh aliases are fine.
- Nothing is gitignored. Machine-local state lives outside the repo
  (`~/.localrc`, `~/.zshrc.local`, `~/.bashrc.local`, `~/.gitconfig`).
- This NAS clone (`~/agent/dotfiles`) is the working copy for edits. Each host
  applies from its own clone at `~/.local/share/chezmoi` (June included), so
  after pushing run `dotfiles-sync` to roll the change out.
- **`git pull` before editing**: the fleet board commits pin bumps to `main`
  by itself (author Kounex, message `chore(tools): …(fleet board)`).

## Rules

- **Don't shadow standard commands** (`ls`, `cat`, `grep`, `cd`, `rm`, ...).
  Claude Code snapshots aliases from the user's shell; herdr panes and
  unattended runs (`FLEET_UNATTENDED=1`) type plain commands and parse output.
  New names only (`ll`, `z`, `bat`). `~/.bashrc` drops rm/cp/mv `-i` aliases
  when `FLEET_UNATTENDED` or `CLAUDECODE` is set; keep that.
  "Standard" includes any binary a package can install: `gs` was
  `git status -sb` until Ghostscript (binary `gs`) came in, now `gst`
  (2026-10-28). Before adding an alias, check the name with `command -v`;
  before adding a package, check its binary names against the aliases in
  `home/dot_config/shell/`.
- **Nothing interactive or slow before the interactive guard** in `~/.bashrc`,
  and nothing but PATH in `~/.zshenv`. `ssh host 'cmd'` sources those.
- **Pin every download** in `home/.chezmoidata/tools.yaml`, never "latest".
  Same rule as container images (root AGENTS.md). The fleet board watches
  these pins and updates them like images (see "Fleet board" below), so keep
  one `name: "version"` per line; it edits by line.
- **Linux tools come as static musl binaries** via `.chezmoiexternal.toml.tmpl`,
  never apt/dnf. UGOS (June) must not have packages installed (see
  `it-env/docs/machines/nas-ops.md`); Optiplex's Debian 11 is too old.
- **Mac packages go through the Brewfile.** Asked to install something on the
  Mac, add it here (push, `dotfiles-sync macbook`) instead of a bare
  `brew install`; chezmoi then runs `brew bundle install --no-upgrade`. If
  something was installed by hand, refresh the file (`brew bundle dump
  --force --file=…`, see the file header).
- Test template changes before pushing:
  `chezmoi --source ~/agent/dotfiles --destination /tmp/x --cache /tmp/x.cache --persistent-state /tmp/x.db apply`
  renders for the local host (pick a different `--destination` and clean up
  after). `chezmoi execute-template` checks a single template.

## Fleet board

`fleet-board/updater/dotfiles.py` (since 2026-10-27) turns every pin in
`tools.yaml` into an update unit on fleet.kounex.com ("Dotfiles tools").
An update commits the new pin from the board's own clone
(`~/.local/state/fleet-board-updater/dotfiles-repo`), runs `chezmoi update`
on every host, checks `chezmoi verify`, the new version and that the shell
starts, and reverts + re-syncs on any failure. Patch and minor bumps are
automatic in the 04:00 window (0.x minors too: these are interactive-only
tools), majors wait for a decision, chezmoi itself is patch-only automatic.
Hosts that were offline catch up at the next check. A new pinned tool needs
an entry in `TOOLS` there (repo, binary, version check).

## Hosts

`home/.chezmoidata/hosts.yaml` maps short hostnames to prompt name/colour and
marks agent hosts (`agent: true` installs `dotfiles-sync`). Hostnames are the
real ones (`CentOS-90-stream-amd64-base` is the big Hetzner box,
`june-hetzner-ubuntu` the VPS, `solaire` the Optiplex/Proxmox host).

## Mac specifics

- Flutter SDK is a plain git clone at `~/development/flutter/sdk` (moved out
  of the old `~/.dotfiles/flutter/sdk` on 2026-10-27).
- Ruby comes from mise (`~/.config/mise/config.toml`, 3.4.2 with fastlane and
  cocoapods gems). rbenv/rvm/jenv are retired.
- Node stays on Homebrew because its global npm CLIs live there.
- `macos-defaults` is never run by chezmoi; it restarts Finder/Dock.
