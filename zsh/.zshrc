# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Docker completion (autoload -Uz compinit && compinit -i)
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

if [ "$TMUX" = "" ]; then tmux; fi
