#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
# If .bashrc exists
if [ -f $HOME/.bashrc ]; then
    echo -e "\n\n# Source bashrc from dotfiles\nsource ${BASEDIR}/bashrc" >> $HOME/.bashrc
else
    ln -s ${BASEDIR}/bashrc ~/.bashrc
fi

# git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig

# vscode
ln -s ${BASEDIR}/vscode_settings.json ~/.config/Code/User/settings.json
