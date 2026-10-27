# Environment shared by bash and zsh (interactive shells).

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS=-R
export CLICOLOR=1

# `c <project>` jumps here (see aliases.sh). ~/.localrc may override.
if [ -z "$PROJECTS" ]; then
  if [ -d "$HOME/agent" ]; then PROJECTS=$HOME/agent; else PROJECTS=$HOME/development; fi
fi
export PROJECTS
