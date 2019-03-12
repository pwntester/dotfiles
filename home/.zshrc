unset ZPLUG_CLONE_DEPTH
unset ZPLUG_CACHE_FILE

# zplug
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
else
    source ~/.zplug/init.zsh
fi

zplug 'zplug/zplug',                            hook-build:'zplug --self-manage'
zplug "modules/tmux",                           from:prezto
zplug "modules/history",                        from:prezto
zplug "modules/utility",                        from:prezto
zplug "modules/ruby",                           from:prezto
zplug "modules/ssh",                            from:prezto
zplug "modules/terminal",                       from:prezto
zplug "modules/directory",                      from:prezto
zplug "modules/completion",                     from:prezto
zplug "modules/history-substring-search",       from:prezto, defer:3
zplug "mafredri/zsh-async",                     from:github
zplug "sindresorhus/pure",                      use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting"
zplug "tarruda/zsh-autosuggestions"           
zplug "felixr/docker-zsh-completion"
zplug "davidparsson/zsh-pyenv-lazy"
zplug "BurntSushi/ripgrep",                     defer:3, from:"gh-r", as:"command", use:"*darwin*", rename-to:"rg"
zplug "junegunn/fzf-bin",                       defer:3, from:"gh-r", as:"command", use:"*darwin*", rename-to:"fzf"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load 

if zplug check zsh-users/zsh-autosuggestions; then
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down)
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}")
fi

if zplug check zsh-users/zsh-history-substring-search; then
    bindkey '\eOA' history-substring-search-up
    bindkey '\eOB' history-substring-search-down
fi

# autoload
fpath=(~/.zsh "${fpath[@]}")
autoload -Uz bip tmuxify

# every time we load .zshrc, ditch duplicate path entries
typeset -U PATH fpath

# bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# aliases 
alias awb="auditworkbench"
alias sca="sourceanalyzer"
alias vi='nvim'
alias ctags="`brew --prefix`/bin/ctags"
alias pg-start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg-stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias ls='gls --color=auto --group-directories-first'
alias tree="exa --tree"

# language
if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
fi
if [[ -z "$LC_ALL" ]]; then
	export LC_ALL='en_US.UTF-8'
fi

# OS detection
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
   platform='macosx'
elif [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
fi

# browser
if [[ "$OSTYPE" == darwin* ]]; then
	export BROWSER='open'
fi

# variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export SHELL=`which zsh`
export TERM="screen-256color"  
export NODE_PATH="/usr/local/lib/node"
# export JAVA_9_HOME=/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home
# export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
# export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
# export JAVA_HOME=$JAVA_8_HOME
export ANT_OPTS="-XX:MaxPermSize=256m" 
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/Applications/HP_Fortify/sca/bin:/Applications/HP_Fortify/awb_main/bin:/Users/alvaro/bin:$HOME/.cargo/bin:$PATH
export EXA_COLORS="uu=38;5;249:un=38;5;241:gu=38;5;245:gn=38;5;241:da=38;5;245:sn=38;5;7:sb=38;5;7:ur=38;5;3;1:uw=38;5;5;1:ux=38;5;1;1:ue=38;5;1;1:gr=38;5;249:gw=38;5;249:gx=38;5;249:tr=38;5;249:tw=38;5;249:tx=38;5;249:fi=38;5;255:di=38;5;74:ex=38;5;1:xa=38;5;12:*.png=38;5;4:*.jpg=38;5;4:*.gif=38;5;4"

# options
setopt SHARE_HISTORY
setopt extended_glob
setopt prompt_subst
setopt auto_cd

# vi(m) style key bindings.
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins 'jk' vi-cmd-mode
bindkey 'jk' vi-cmd-mode

# fzf 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# fv [FUZZY PATTERN] - Open the selected file with neovim 
fvi() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && nvim "${files[@]}"
}

# fd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

tmuxify

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/alvaro/.sdkman"
[[ -s "/Users/alvaro/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/alvaro/.sdkman/bin/sdkman-init.sh"
