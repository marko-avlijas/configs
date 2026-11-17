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

The repo can live anywhere under `$HOME` (`~/configs`, or `~/dotfiles/config`
as a submodule of the private install repo); links point to where it is.

Machine-specific shell settings (paths, env vars of one computer) go in
`~/.config/shell/local.sh`, which `shell/bash_and_zsh.sh` sources if it exists.
It is not part of this repo.


To install tpm (tmux plugin manager)

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Press prefix + I (inside tmux) to install tmux plugins
