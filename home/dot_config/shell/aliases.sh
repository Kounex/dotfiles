# General aliases and functions, bash + zsh.
#
# Rule: never shadow a standard command (ls, cat, grep, cd, rm, ...).
# Agents (Claude Code snapshots these, herdr panes, unattended runs) type
# the plain names and parse the output; new names only.

alias reload='exec "${SHELL:-bash}" -l'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'

if command -v eza >/dev/null 2>&1; then
  alias l='eza -lh --group-directories-first'
  alias ll='eza -lh --git --group-directories-first'
  alias la='eza -lah --git --group-directories-first'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  alias l='ls -lh'
  alias ll='ls -lh'
  alias la='ls -lAh'
fi

# Jump to a project: c <name>
c() { cd "$PROJECTS/$1" || return; }

mkcd() { mkdir -p "$1" && cd "$1" || return; }

# extract <archive>
extract() {
  [ -f "$1" ] || { echo "extract: '$1' is not a file" >&2; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar -xjvf "$1" ;;
    *.tar.gz|*.tgz)   tar -xzvf "$1" ;;
    *.tar.xz)         tar -xJvf "$1" ;;
    *.tar.zst)        tar --zstd -xvf "$1" ;;
    *.tar)            tar -xvf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.xz)             unxz "$1" ;;
    *.zip|*.ZIP)      unzip "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.Z)              uncompress "$1" ;;
    *.dmg)            hdiutil mount "$1" ;;
    *) echo "extract: don't know how to extract '$1'" >&2; return 1 ;;
  esac
}
