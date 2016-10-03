alias awb="auditworkbench"
alias sca="sourceanalyzer"
alias tmux="TERM=screen-256color-bce tmux"
alias vi='nvim'
alias burp='java -Xmx2048m -XX:MaxPermSize=1G -Xdock:name="Burp" -Xdock:icon=/Users/alvaro/CTFs/tools/Burp/icon.png -jar /Users/alvaro/CTFs/tools/Burp/burp.jar &'

# Path
path=(
	/usr/local/mysql/bin
	/Users/alvaro/bin
	/usr/local/share/npm/bin
	/Applications/HP_Fortify/sca_main/bin
	/Applications/HP_Fortify/awb_main/bin
	/Applications/HP_Fortify/sca/bin
	$path
)

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

export XDG_CONFIG_HOME=$HOME/.config
export NODE_PATH="/usr/local/lib/node"
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/Applications/HP_Fortify/sca_main/bin:/Applications/HP_Fortify/awb_main/bin:/Applications/HP_Fortify/sca/bin:$PATH
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
export JAVA_HOME=$JAVA_8_HOME
export PKG_CONFIG_PATH=/usr/local/Cellar/cairo/1.12.16_1/lib/pkgconfig:/usr/local/opt/pixman/lib/pkgconfig:/usr/local/opt/fontconfig/lib/pkgconfig:/usr/local/opt/freetype/lib/pkgconfig:/usr/local/opt/libpng/lib/pkgconfig:/opt/X11/lib/pkgconfig
export ANT_OPTS=-XX:MaxPermSize=256m
setopt AUTO_CD

# Use Vi(m) style key bindings.
bindkey -v

# Use jk to exit insert mode (jj is too slow).
bindkey -M viins 'jk' vi-cmd-mode

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
