# Steam Deck Dev Machine dotfiles

Dotfiles to unlock general development capabilities on a Steam Deck.

- Keeps SteamOS's read-only mode & stability
- Enables VSCode devcontainer development on arbitrary sets of containers (node, postgres, etc)
- Enables Docker & Docker-compose
- Enables OpenVPN and pulls down NordVPN's ovpn configs
- Works alongside Steam Deck updates and even re-imaging the Deck

## How it works

- Applies all changes via an idempotent `~/.decksetup.sh` script
- Connects flatpak (vscode) to podman via podman-docker and docker-compose

## How it's tested

Tested via:

1. [Reimaging](https://help.steampowered.com/en/faqs/view/1B71-EDF2-EB6D-2BB3) the deck back to factory state
2. Following the instructions in **Quick start** below

## Examples

- `~/test/node` shows running a node devcontainer with vscode's default config
  - demonstrates using `runArgs` and `containerUser` to work as a non-root user
- `~/test/node-pg` shows running node & postgres simultaneously with docker-compose
  - uses vscode's default config, after commenting out the non-root user

## Quick start

You probably want to fork these dotfiles & read through them to tune to your preferences.
Otherwise, after running these commands, your Deck will be identical to mine.

These are managed via the popular [HackerNews dotfiles strategy](https://news.ycombinator.com/item?id=11070797):

```bash
cd ~
git init --bare ~/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
dotfiles remote add origin git@github.com:hunterloftis/dotfiles.git
dotfiles pull origin main
./.decksetup.sh
```
