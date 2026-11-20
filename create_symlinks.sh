#!/usr/bin/env bash
# Symlink the config files in this repo into $HOME. Works from wherever the
# repo is cloned (e.g. ~/configs, or ~/dotfiles/config as a submodule), as
# long as it is under $HOME: links are relative to $HOME.
set -eu

echo "Creating symlinks:"

DOTFILES_DIR_ABS="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
case "$DOTFILES_DIR_ABS" in
  "$HOME"/*) ;;
  *) echo "error: $DOTFILES_DIR_ABS is not under \$HOME" >&2; exit 1 ;;
esac
DOTFILES_DIR_REL_FROM_HOME="${DOTFILES_DIR_ABS#"$HOME/"}"

echo "Symlinking git"
git_dotfiles=( "gitconfig" "gitignore_global" "gitconfig_secret" )
for i in "${git_dotfiles[@]}"; do
  ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/git/$i" "$HOME/.$i"
done

echo "Symlinking tmux: ~/.config/tmux -> tmux/"
mkdir -p "$HOME/.config"
# an old ~/.tmux.conf would be loaded instead of ~/.config/tmux/tmux.conf
if [ -L "$HOME/.tmux.conf" ]; then
  rm -v "$HOME/.tmux.conf"
elif [ -e "$HOME/.tmux.conf" ]; then
  echo "warning: ~/.tmux.conf is a real file and overrides ~/.config/tmux; move it away" >&2
fi
if [ -e "$HOME/.config/tmux" ] && [ ! -L "$HOME/.config/tmux" ]; then
  echo "warning: ~/.config/tmux is a real directory, not linking; move it away" >&2
else
  ln -sfnv "../$DOTFILES_DIR_REL_FROM_HOME/tmux" "$HOME/.config/tmux"
fi
"$HOME/.config/tmux/install-resurrect.sh"

# Vim is not used any more: remove the link to the vimrc this repo had
if [ -L "$HOME/.vimrc" ]; then
  case "$(readlink "$HOME/.vimrc")" in */vim/vimrc) rm -v "$HOME/.vimrc" ;; esac
fi

echo "Symlinking neovim: ~/.config/nvim -> nvim/"
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "warning: ~/.config/nvim is a real directory (old vim-plug setup?), not linking;" >&2
  echo "         move it away: mv ~/.config/nvim ~/.config/nvim.old" >&2
else
  ln -sfnv "../$DOTFILES_DIR_REL_FROM_HOME/nvim" "$HOME/.config/nvim"
fi


# Appends given text to given file
# only if file already doesn't contain the text
#
# $1 - path of file to change
# $2 - text to add at the end of file

# Message is outputed to user that text was added or that it was skipped
# because text was already present in file

# Example:
# smart_append_to_file "$HOME/.zshrc" \
#                      "source /usr/local/share/chruby/chruby.sh"

smart_append_to_file() {
  local path="$1"
  local text="$2"

  if grep -qsF -- "$text" "$path"; then
    echo "Skipping - already present in $path:\n\t\t$text"
  else
    echo "$text" >> "$path" # append $text to $path
    echo "Added to $path: $text"
  fi

  return 0
}

# Configure bash and zsh
# append: source "$DOTFILES_DIR_ABS/config/shell/bash_and_zsh.sh"
# to ~/.bashrc and ~/.zshrc
echo "Patching .bashrc and .zshrc"
source_bash_and_zsh="source "$DOTFILES_DIR_ABS/shell/bash_and_zsh.sh""

# append to ~/.bashrc
smart_append_to_file "$HOME/.bashrc" "# Load my configuration"
smart_append_to_file "$HOME/.bashrc" "$source_bash_and_zsh"

# append to ~/.zshrc
smart_append_to_file "$HOME/.zshrc" "# Load my configuration"
smart_append_to_file "$HOME/.zshrc" "$source_bash_and_zsh"
smart_append_to_file "$HOME/.zshrc" "source "$DOTFILES_DIR_ABS/shell/zsh.zsh""

