#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
if [ -f $HOME/.bashrc ]; then
    if grep -q "Source bashrc from dotfiles" $HOME/.bashrc; then
        echo "Bash: Already exists"
    else
        echo "Bash: Adding sourcing of bashrc to the existing .bashrc"
        echo "" >> $HOME/.bashrc
        echo "# Source bashrc from dotfiles" >> $HOME/.bashrc
        echo "source ${BASEDIR}/bashrc" >> $HOME/.bashrc
        echo "" >> $HOME/.bashrc
    fi
else
    echo "Bash: Please create a .bashrc"
fi

# git
if [ -f $HOME/.gitconfig ]; then 
    link=$(readlink -f "$HOME/.gitconfig")
    if [ "$link" == "${BASEDIR}/gitconfig" ]; then
        echo "Git: Already exists"
    else
        echo "Git: Please delete the existing .gitconfig to allow for the symlink"
    fi
else
    echo "Git: Adding symling to gitconfig"
    ln -s ${BASEDIR}/gitconfig ~/.gitconfig
fi

# vscode
loc_from=$HOME/.config/Code/User/settings.json
loc_to=${BASEDIR}/vscode_settings.json
if [ -f $loc_from ]; then
    link=$(readlink -f "$loc_from")
    if [ "$link" == "$loc_to" ]; then
        echo "VSCode: Already exists"
    else
        echo "VSCode: Please delete the existing $loc_from to allow for the symlink"
    fi
else
    echo "VSCode: Adding symlink to vscode settings"
    ln -s $loc_to $loc_from
fi
