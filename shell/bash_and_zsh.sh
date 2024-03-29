export EDITOR='vi' # is symlinked to nvim, check out configure nvim & vim script

alias be='bundle exec'
alias tn='tmux new -s "$(basename $(pwd))"'

# Enable chruby
source /usr/local/share/chruby/chruby.sh
# Make chruby automatically change ruby version as you cd into project
source /usr/local/share/chruby/auto.sh

# Enable nvm
# export NVM_DIR="$HOME/src/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
