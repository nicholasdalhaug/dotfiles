#!/bin/bash

HEADLESS=false
if [ $# -ne 0 ]; then
    if [ $1 == "--headless" ]; then
        HEADLESS=true
    else
        echo "Usage: install.bash [--headless]"
        exit 1
    fi
fi

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# zsh
if which zsh > /dev/null; then
    echo "ZSH: Already exists"
else
    echo "ZSH: Installing zsh"
    sudo apt-get install -y zsh

    # Set zsh to default shell
    chsh -s /bin/zsh

    ln -s ${BASEDIR}/zshrc ~/.zshrc

    if ! [ -f "/etc/zsh_command_not_found" ]; then
        sudo apt-get install -y command-not-found
    fi
fi

if ! [ -d $HOME/.oh-my-zsh ]; then
    echo "ZSH: Installing Oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

    # Install powerline fonst to use agnoster theme
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts

    # Set the font to default for the terminal
    # Take the first profile
    if ! $HEADLESS; then
        profile_id=$(dconf dump /org/gnome/terminal/legacy/profiles:/ | awk '/\[:/||/visible-name=/' | sed -n '1p' | sed -r 's/^\[(.*)\]$/\1/')
        dconf write /org/gnome/terminal/legacy/profiles:/$profile_id/use-system-font "false"
        dconf write /org/gnome/terminal/legacy/profiles:/$profile_id/font "'Meslo LG S for Powerline 10'"
    fi

    # Get autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

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
if ! $HEADLESS; then
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
fi
