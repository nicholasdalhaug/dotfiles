# My dotfiles
Remove:
* .gitconfig
* Global user settings for vscode (read the script)

Run this simple script
```bash
./install.bash
```
It will
* Append sourcing of this new bashrc file to the end of the .bashrc, or create a new symlink
* Create a symlink to this `.gitignore`
* Create a symlink to this VSCode `settings.json`
