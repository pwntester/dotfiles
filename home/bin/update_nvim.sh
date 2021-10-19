#!/bin/bash
cd ~/dev
sudo rm -r neovim
git clone https://github.com/neovim/neovim
cd neovim
sudo make CMAKE_BUILD_TYPE=Release install
