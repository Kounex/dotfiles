# macOS only.

export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=30
export HOMEBREW_AUTOREMOVE=1
export HOMEBREW_NO_ENV_HINTS=1

# Copy my public key to the clipboard.
pubkey() {
  local k
  for k in ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub; do
    [ -f "$k" ] && { pbcopy < "$k"; echo "=> $k copied to clipboard"; return; }
  done
  echo "pubkey: no public key found" >&2; return 1
}
