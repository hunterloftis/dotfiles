# dotfiles
personal dotfiles (steam deck dev machine)

## init a steam deck

```bash
cd ~
git init --bare ~/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
dotfiles remote add origin git@github.com:hunterloftis/dotfiles.git
dotfiles pull origin main
./.decksetup.sh
```
