#!/bin/bash
cd ~/src/github.com/neovim
sudo rm -r neovim
git clone --depth 1 https://github.com/neovim/neovim
cd neovim
# git apply ~/bin/nvim_foldcolumn.diff
sudo make CMAKE_BUILD_TYPE=Release install
