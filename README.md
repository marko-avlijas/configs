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


## tmux

The `tmux/` directory is linked to `~/.config/tmux` (tmux >= 3.2, Linux and
macOS). No plugin manager and no theme plugin: the Dracula-colored status bar
is written in `tmux.conf`; `tmux/status-info.sh` supplies battery and network
text from local state only. The separators need a Powerline/Nerd Font.

The one plugin, tmux-resurrect (prefix C-s saves, prefix C-r restores), is
installed at a reviewed, pinned commit by `tmux/install-resurrect.sh`, which
`create_symlinks.sh` runs. To update it, review the new commits and change the
commit in that script.
