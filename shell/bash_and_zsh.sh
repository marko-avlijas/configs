export EDITOR='nvim'

alias be='bundle exec'
alias tn='tmux new -s "$(basename "$(pwd)")"'

# Enable chruby (if installed)
if [ -f /usr/local/share/chruby/chruby.sh ]; then
  source /usr/local/share/chruby/chruby.sh
  # Make chruby automatically change ruby version as you cd into project
  source /usr/local/share/chruby/auto.sh
fi

# Add go to path if installed
if [ -d /usr/local/go/bin ]; then export PATH="$PATH:/usr/local/go/bin"; fi

export PATH="$HOME/.local/bin:$PATH"

# Machine-specific settings live outside this public repo
if [ -f "$HOME/.config/shell/local.sh" ]; then source "$HOME/.config/shell/local.sh"; fi
