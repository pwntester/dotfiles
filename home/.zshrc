# History
# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Input/output
# vi(m) style key bindings.
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins 'jk' vi-cmd-mode
bindkey 'jk' vi-cmd-mode

# aliases 
alias awb="auditworkbench"
alias sca="sourceanalyzer"
alias vi='nvim'
alias ls='gls --color=auto --group-directories-first'
alias tree="exa --tree"

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# completion
# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

# termtitle
# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
zstyle ':zim:termtitle' format '%1~'

# zsh-autosuggestions
# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# zsh-syntax-highlighting
# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# Initialize modules
if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# Post-init module configuration
# zsh-history-substring-search
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# language
if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
fi
if [[ -z "$LC_ALL" ]]; then
	export LC_ALL='en_US.UTF-8'
fi

# variables
export BROWSER='open'
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export SHELL=`which zsh`
#export TERM="screen-256color"  
export TERM="xterm-kitty"
export NODE_PATH="/usr/local/lib/node"
export ANT_OPTS="-XX:MaxPermSize=256m" 
export GOPATH=$(go env GOPATH)
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$PATH:/usr/local/share/npm/bin
export PATH=$PATH:/Applications/Fortify/sca/bin
export PATH=$PATH:/Applications/Fortify/awb_main/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:~/codeql-home/codeql-cli
export EXA_COLORS="uu=38;5;249:un=38;5;241:gu=38;5;245:gn=38;5;241:da=38;5;245:sn=38;5;7:sb=38;5;7:ur=38;5;3;1:uw=38;5;5;1:ux=38;5;1;1:ue=38;5;1;1:gr=38;5;249:gw=38;5;249:gx=38;5;249:tr=38;5;249:tw=38;5;249:tx=38;5;249:fi=38;5;255:di=38;5;74:ex=38;5;1:xa=38;5;12:*.png=38;5;4:*.jpg=38;5;4:*.gif=38;5;4"

# options
setopt SHARE_HISTORY
setopt extended_glob
setopt prompt_subst
setopt auto_cd

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# sdkman
export SDKMAN_DIR="/Users/pwntester/.sdkman"
[[ -s "/Users/pwntester/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/pwntester/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
