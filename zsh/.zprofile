# Alias
alias awb="auditworkbench"
alias sca="sourceanalyzer"
alias vi='nvim'
alias ctags="`brew --prefix`/bin/ctags"

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
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/Applications/HP_Fortify/sca/bin:/Applications/HP_Fortify/awb_main/bin:$PATH
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
export JAVA_HOME=$JAVA_8_HOME
export PKG_CONFIG_PATH=/usr/local/Cellar/cairo/1.12.16_1/lib/pkgconfig:/usr/local/opt/pixman/lib/pkgconfig:/usr/local/opt/fontconfig/lib/pkgconfig:/usr/local/opt/freetype/lib/pkgconfig:/usr/local/opt/libpng/lib/pkgconfig:/opt/X11/lib/pkgconfig
export ANT_OPTS=-XX:MaxPermSize=256m
setopt AUTO_CD

# Use Vi(m) style key bindings.
bindkey -v
export KEYTIMEOUT=1
bindkey -M viins 'jk' vi-cmd-mode
bindkey 'jk' vi-cmd-mode
