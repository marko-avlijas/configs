# My config files (dotfiles)

## Installation

Requires installed git, zsh, ohmyzsh, tmux, neovim.

Setup gitconfig_secret

    cp git/gitconfig_secret.example git/gitconfig_secret

Edit to include your name & email.

    ./create_symlinks.sh


To install tpm (tmux plugin manager)

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Press prefix + I (inside tmux) to install tmux plugins
