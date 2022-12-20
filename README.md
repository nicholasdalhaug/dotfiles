# My dotfiles
Read then run this simple script
```bash
./install.bash
```

It will
* Install zsh
    * Make zsh default
    * Create a symlink .zshrc til this zshrc
    * Install Oh My zsh
    * Install powerline fonts
    * Set font for the first profile in the terminal (destructive)
* Append sourcing of this new bashrc file to the end of the .bashrc
* Create a symlink to this `.gitignore`
* Create a symlink to this VSCode `settings.json`

It should tell you what to do if it is not able to install. 
