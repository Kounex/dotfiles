#!/bin/sh
#
# flutter

if test $(command -v git); then
  echo "  Installing flutter sdk for you."
  echo "  -------------------------------"

  if test "$(uname)" = "Darwin" && test "$(uname -p)" = "arm"; then
    echo "  -> Installing Apple Sillicon Mac prerequisites"
    sudo softwareupdate --install-rosetta --agree-to-license
  fi

  echo "  -> Configure Xcode just to be safe"
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
  sudo xcodebuild -runFirstLaunch

  echo "  -> Download flutter from github"
  git clone https://github.com/flutter/flutter.git -b stable flutter/sdk
  $HOME/.dotfiles/flutter/bin/flutter precache
else
  echo "  MISSING GIT"
fi

exit 0
