echo "Creating symlinks:"

DOTFILES_DIR_ABS="$HOME/configs"
DOTFILES_DIR_REL_FROM_HOME="${DOTFILES_DIR_ABS#"$HOME/"}"

echo "Symlinking git"
git_dotfiles=( "gitconfig" "gitignore_global" "gitconfig_secret" )
for i in "${git_dotfiles[@]}"; do
  ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/git/$i" "$HOME/.$i"
done

echo "Symlinking tmux"
ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/tmux/tmux.conf" "$HOME/.tmux.conf"

# Configure vim
echo "Configuring vim"
ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/vim/vimrc" "$HOME/.vimrc"

# Configure neovim
echo "Configuring neovim"
mkdir -p "$HOME/.config/nvim"
ln -sfv "../../$DOTFILES_DIR_REL_FROM_HOME/neovim/init.vim" \
        "$HOME/.config/nvim/init.vim"


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

  if grep "$text" "$path" > /dev/null; then
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

