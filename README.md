# My config files (dotfiles)

## Installation

Requires installed git, zsh, ohmyzsh, tmux, neovim.

Neovim: use an official build >= 0.10 (github.com/neovim/neovim/releases),
not Ubuntu's apt package: render-markdown.nvim needs the markdown treesitter
parsers that only the official builds bundle. Headings and icons need a Nerd
Font in the terminal.

Setup gitconfig_secret

    cp git/gitconfig_secret.example git/gitconfig_secret

Edit to include your name & email.

    ./create_symlinks.sh


To install tpm (tmux plugin manager)

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Press prefix + I (inside tmux) to install tmux plugins
