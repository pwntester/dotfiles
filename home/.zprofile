# Alias
alias awb="auditworkbench"
alias sca="sourceanalyzer"
alias vi='nvim'
alias ctags="`brew --prefix`/bin/ctags"
alias tree="exa --tree"

# Language
if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
fi
if [[ -z "$LC_ALL" ]]; then
	export LC_ALL='en_US.UTF-8'
fi

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
	export BROWSER='open'
fi

# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Variables
export XDG_CONFIG_HOME=$HOME/.config
export NODE_PATH="/usr/local/lib/node"
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/Applications/HP_Fortify/sca/bin:/Applications/HP_Fortify/awb_main/bin:$PATH:/Users/alvaro/bin
export JAVA_9_HOME=/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
export JAVA_HOME=$JAVA_8_HOME
export PKG_CONFIG_PATH=/usr/local/Cellar/cairo/1.12.16_1/lib/pkgconfig:/usr/local/opt/pixman/lib/pkgconfig:/usr/local/opt/fontconfig/lib/pkgconfig:/usr/local/opt/freetype/lib/pkgconfig:/usr/local/opt/libpng/lib/pkgconfig:/opt/X11/lib/pkgconfig
export ANT_OPTS=-XX:MaxPermSize=256m
export SHELL=`which zsh`
export ANT_OPTS="-XX:MaxPermSize=256m -Dhttp.proxyHost=proxy.houston.hpecorp.net -Dhttp.proxyPort=8080 -Dhttps.proxyHost=proxy.houston.hpecorp.net -Dhttps.proxyPort=8080" 
export PATH="$HOME/.cargo/bin:$PATH"
setopt AUTO_CD
export TERM="screen-256color"  

# Use Vi(m) style key bindings.
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins 'jk' vi-cmd-mode
bindkey 'jk' vi-cmd-mode


# fzf scripts

# fv [FUZZY PATTERN] - Open the selected file with the default editor
fv() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fc - Searching file contents
ffc() {
    grep --line-buffered --color=never -r "" * | fzf
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



