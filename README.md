# Dotfiles
These are my personal bash aliases and functions I use on a daily basis bundeled with my dotfiles

## Installation

```bash
echo "source /home/${USER}/dotfiles/sourcer" >> ~/.bashrc
(crontab -l 2>/dev/null; echo "*/10 * * * * cd /home/${USER}/dotfiles/ && git pull") | crontab -
ln -sf /home/${USER}/dotfiles/gitconfig ~/.gitconfig
```