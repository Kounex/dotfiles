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

## Rules

- **Don't shadow standard commands** (`ls`, `cat`, `grep`, `cd`, `rm`, ...).
  Claude Code snapshots aliases from the user's shell; herdr panes and
  unattended runs (`FLEET_UNATTENDED=1`) type plain commands and parse output.
  New names only (`ll`, `z`, `bat`). `~/.bashrc` drops rm/cp/mv `-i` aliases
  when `FLEET_UNATTENDED` or `CLAUDECODE` is set; keep that.
- **Nothing interactive or slow before the interactive guard** in `~/.bashrc`,
  and nothing but PATH in `~/.zshenv`. `ssh host 'cmd'` sources those.
- **Pin every download** in `home/.chezmoidata/tools.yaml`, never "latest".
  Same rule as container images (root AGENTS.md).
- **Linux tools come as static musl binaries** via `.chezmoiexternal.toml.tmpl`,
  never apt/dnf. UGOS (June) must not have packages installed (see
  `it-env/docs/machines/nas-ops.md`); Optiplex's Debian 11 is too old.
- **Mac packages go through the Brewfile.** After a manual `brew install`,
  refresh it (`brew bundle dump --force --file=…`, see the file header).
- Test template changes before pushing:
  `chezmoi --source ~/agent/dotfiles --destination /tmp/x --cache /tmp/x.cache --persistent-state /tmp/x.db apply`
  renders for the local host (pick a different `--destination` and clean up
  after). `chezmoi execute-template` checks a single template.

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
