# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/pwntester/dotfiles/config/nvim/pack/minpac/start/fzf/bin* ]]; then
  export PATH="$PATH:/Users/pwntester/dotfiles/config/nvim/pack/minpac/start/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/pwntester/dotfiles/config/nvim/pack/minpac/start/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/pwntester/dotfiles/config/nvim/pack/minpac/start/fzf/shell/key-bindings.zsh"

