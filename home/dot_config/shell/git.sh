# git aliases (settings live in ~/.config/git/config).

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gm='git merge'
alias gl='git pull --prune'
alias gp='git push origin HEAD'
alias gac='git add -A && git commit -m'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
# main -> release, push, back to main
alias gelease='git checkout release && git merge main && git push && git checkout main'

# gf <branch>: check out a remote branch as a local tracking branch
gf() { git checkout -b "$1" "origin/$1"; }
