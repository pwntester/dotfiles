# GLOBAL
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

install_xterm_kitty_terminfo() {
  # Attempt to get terminfo for xterm-kitty
  if ! infocmp xterm-kitty &>/dev/null; then
    echo "xterm-kitty terminfo not found. Installing..."
    # Create a temp file
    tempfile=$(mktemp)
    # Download the kitty.terminfo file
    # https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
    if curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo; then
      echo "Downloaded kitty.terminfo successfully."
      # Compile and install the terminfo entry for my current user
      if tic -x -o ~/.terminfo "$tempfile"; then
        echo "xterm-kitty terminfo installed successfully."
      else
        echo "Failed to compile and install xterm-kitty terminfo."
      fi
    else
      echo "Failed to download kitty.terminfo."
    fi
    # Remove the temporary file
    rm "$tempfile"
  fi
}

# HISTORY
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ZINIT
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# OH-MY-POSH
zinit lucid \
  as"program" from"gh-r"  \
  cp'posh-* -> oh-my-posh' pick'oh-my-posh' \
  atload'eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"' \
  light-mode for @JanDeDobbeleer/oh-my-posh

# ZSH-VI-MODE
zinit wait depth=1 lucid \
  atload' \
    export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk; \
    export ZVM_VI_SURROUND_BINDKEY=s-prefix; \
    export ZVM_INIT_MODE=sourcing; \
    export ZVM_LINE_INIT_MODE=i; \
    export ZSH_AUTOSUGGEST_MANUAL_REBIND=1'\
  light-mode for @jeffreytse/zsh-vi-mode

# ZSH-HISTORY-SUBSTRING
zinit wait lucid \
  atload"bindkey '^[[A' history-substring-search-up; \
    bindkey '^[[B' history-substring-search-down" \
    for zsh-users/zsh-history-substring-search

# ZSH-COMPLETIONS
zinit wait blockf lucid \
  atload"zicompinit; zicdreplay; install_xterm_kitty_terminfo" \
  light-mode for @zsh-users/zsh-completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # partial completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:*:*:*' menu select # menu no
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ZSH-AUTOSUGGESTIONS
zinit wait lucid \
  atload'_zsh_autosuggest_start; \
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"; \
  bindkey "^\\" autosuggest-toggle; \
  bindkey "^I" complete-word # tab; \
  bindkey "^[[Z" vi-forward-word # shift-tab' \
  light-mode for @zsh-users/zsh-autosuggestions 

# SNIPPETS
zinit snippet OMZP::git 
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit as'completion' is-snippet for 'OMZP::fd/_fd'
zinit as'completion' is-snippet for 'OMZP::docker-compose/_docker-compose'
zinit snippet OMZ::plugins/git/git.plugin.zsh

# ZSH-SYNTAX-HIGHLIGHTING (keep at the bottom)
zinit wait lucid \
  atload'source ~/.config/zsh/catppuccin_machiatto-zsh-syntax-highlighting.zsh' \
  light-mode for @zsh-users/zsh-syntax-highlighting

builtin source ~/.config/zsh/aliases.sh
builtin source ~/.config/zsh/zshenv.sh
builtin source ~/.config/zsh/functions.sh
builtin source ~/.config/wezterm/shell-integration.sh

load_pyenv
eval "$(zoxide init zsh)"
