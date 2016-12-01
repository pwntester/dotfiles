# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Docker completion (autoload -Uz compinit && compinit -i)
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# virtualenv
export WORKON_HOME=~/virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# OS detection
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
   platform='macosx'
elif [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
fi

# angr on macosx
if [[ "$platform" == 'macosx' ]]; then
    export DYLD_LIBRARY_PATH=/Users/alvaro/CTFs/tools/angr-unicorn:/Users/alvaro/virtualenvs/angr_pypy/site-packages/pyvex/lib
fi

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [ "$TMUX" = "" ]; then tmux; fi
