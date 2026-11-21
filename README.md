# My config files (dotfiles)

## Installation

Requires installed git, zsh, ohmyzsh, tmux, neovim; fd is optional.

Neovim: an official build >= 0.12 (github.com/neovim/neovim/releases or brew),
not Ubuntu's apt package, which is too old. Vim is not configured any more.

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

## Neovim

`nvim/` is linked to `~/.config/nvim`. The default colorscheme, CTRL p is the
built-in `:find` turned into a fuzzy picker (file list from `fd`, if
installed), CTRL n toggles the built-in netrw file tree.

Plugins are managed by the built-in `vim.pack`: render-markdown.nvim and
nvim-web-devicons (its icons). Both are pinned to a commit in `nvim/init.lua`
and in the lockfile `nvim/nvim-pack-lock.json`. `nvim/install-plugins.sh`,
which `create_symlinks.sh` runs, installs them at those commits. To update
one, see the comment in `init.lua`. The icons need a Nerd Font.
