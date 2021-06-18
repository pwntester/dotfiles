#!/bin/bash
cd ~/Dev
sudo rm -r neovim
git clone https://github.com/neovim/neovim
cd neovim
sudo make CMAKE_BUILD_TYPE=Release install
cd ~/Dev
sudo rm -r neovim
