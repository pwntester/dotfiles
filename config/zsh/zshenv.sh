# system
export EDITOR=nvim
export VISUAL=nvim
export SHELL=$(which zsh)

# path
export PATH=$PATH:/usr/local/opt/gnu-sed/libexec/gnubin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/local/share/npm/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin

export XDG_CONFIG_HOME="$HOME/.config"
export AICHAT_CONFIG_DIR="$XDG_CONFIG_HOME/aichat"

export FZF_DEFAULT_OPTS=" \
    --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
    --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
    --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

# secrets
source ~/.config/secrets/env

# go
if [ -x "$(command -v go)" ]; then
  export GOPATH=$(go env GOPATH)
  export PATH=$PATH:$(go env GOPATH)/bin
fi
