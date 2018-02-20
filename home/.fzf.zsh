# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/alvaro/dotfiles/config/nvim/dein/repos/github.com/junegunn/fzf/bin* ]]; then
  export PATH="$PATH:/Users/alvaro/dotfiles/config/nvim/dein/repos/github.com/junegunn/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/alvaro/dotfiles/config/nvim/dein/repos/github.com/junegunn/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/alvaro/dotfiles/config/nvim/dein/repos/github.com/junegunn/fzf/shell/key-bindings.zsh"

