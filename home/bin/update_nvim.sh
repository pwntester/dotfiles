#!/bin/bash
cd ~/src/github.com/neovim
sudo rm -r neovim
git clone --depth 1 https://github.com/neovim/neovim
cd neovim
sudo make CMAKE_BUILD_TYPE=Release
sudo make CMAKE_INSTALL_PREFIX=$HOME/local/nvim install
# sudo make CMAKE_BUILD_TYPE=Release install
