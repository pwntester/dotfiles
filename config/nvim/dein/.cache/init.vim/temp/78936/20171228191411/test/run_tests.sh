#!/usr/bin/env zsh

nvim -Nu <(cat << EOF
filetype off
set rtp+=~/.config/nvim/plugged/vader.vim
set rtp+=~/.config/nvim/plugged/vim-repeat
set rtp+=~/.config/nvim/plugged/neomake
set rtp+=~/.config/nvim/plugged/vim-commentary
set rtp+=~/.config/nvim/plugged/vim-airline
set rtp+=~/.config/nvim/plugged/ultisnips
set rtp+=~/.config/nvim/plugged/vim-fortify
set rtp+=~/.config/nvim/plugged/vim-fortify/ftdetect
set rtp+=~/.config/nvim/plugged/vim-fortify/ftplugin
set rtp+=~/.config/nvim/plugged/vim-fortify/after
filetype plugin indent on
syntax enable
EOF) -c 'Vader *.vader'
