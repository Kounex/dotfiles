# dotfiles

Shell environment for every machine I SSH into: one prompt, the same aliases
and git setup, and modern CLI tools, on a zsh Mac and on bash Linux servers.
Managed with [chezmoi](https://chezmoi.io).

## Install on a new host

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply Kounex
```

No prompts. It clones this repo to `~/.local/share/chezmoi` and writes the
files below into `$HOME`. Existing files it replaces are overwritten, so
back up a hand-edited `~/.bashrc` first. Add the host to
`home/.chezmoidata/hosts.yaml` to give it a prompt name and colour.

## Day to day

| Task | Command |
|---|---|
| Change a managed file | `chezmoi edit ~/.zshrc` (or edit in `~/.local/share/chezmoi`), then `chezmoi apply` |
| See what would change | `chezmoi diff` |
| Commit and push | `chezmoi cd`, then git as usual |
| Pull + apply on this host | `chezmoi update` |
| Update the whole fleet (from June or the Mac) | `dotfiles-sync` (or `dotfiles-sync hetzner optiplex`) |

## Layout

Everything chezmoi deploys lives in `home/` (`.chezmoiroot`).

| Source | Becomes | Notes |
|---|---|---|
| `dot_config/shell/*.sh` | `~/.config/shell/` | The topics. Shared by bash and zsh. `path.sh` sets PATH for every shell, the rest are sourced by interactive shells. Add a topic by adding a file. |
| `dot_zshenv`, `dot_zshrc` | `~/.zshenv`, `~/.zshrc` | Mac. No framework: three pinned plugins, cached completions. |
| `dot_bashrc` | `~/.bashrc` | Linux. PATH + `~/.localrc` for every shell, the rest only when interactive. |
| `dot_config/starship.toml.tmpl` | `~/.config/starship.toml` | Prompt. Host label and colour come from `.chezmoidata/hosts.yaml`. |
| `dot_config/git/` | `~/.config/git/{config,ignore}` | Shared git settings. Credential helpers stay in each host's own `~/.gitconfig`. |
| `dot_vimrc` | `~/.vimrc` | Plugin-free, works with vim-tiny. |
| `dot_config/homebrew/Brewfile` | `~/.config/homebrew/Brewfile` | Mac packages; `brew bundle` runs when it changes. |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | Mac runtimes (Ruby for fastlane/CocoaPods). |
| `.chezmoiexternal.toml.tmpl` | `~/.local/bin/*`, zsh plugins | Pinned downloads; versions in `.chezmoidata/tools.yaml`. |
| `dot_local/bin/` | `~/.local/bin/` | `dotfiles-sync` (agent hosts), `macos-defaults` (Mac, run by hand). |

## Not in this repo, on purpose

- `~/.localrc`: secrets and machine-only env. Sourced by every shell, never committed.
- `~/.zshrc.local`, `~/.bashrc.local`: anything an installer wants to append,
  or a setting for one machine only. Sourced last.
- `~/.gitconfig`: per-host credential helper (`gh auth setup-git`, keychain).

This repo is public: no secrets, IPs or private hostnames in tracked files.

## History

Before 2026-10-27 this was a holman-style topic repo forked from
PixelJonas/dotfiles. It's archived as
[Kounex/dotfiles-legacy](https://github.com/Kounex/dotfiles-legacy).
