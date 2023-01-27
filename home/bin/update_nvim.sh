#!/bin/bash
cd ~/src/github.com/neovim
sudo rm -r neovim
#git clone --depth 1 --branch v0.6.1 https://github.com/neovim/neovim
git clone --depth 1 https://github.com/neovim/neovim
cd neovim
sudo make CMAKE_BUILD_TYPE=Release install
