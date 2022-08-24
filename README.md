# Steam Deck Dev Machine dotfiles

Dotfiles to unlock general development capabilities on a Steam Deck.

- Keeps SteamOS's read-only mode & stability
- Enables VSCode devcontainer development on arbitrary sets of containers (node, postgres, etc)
- Enables Docker & Docker-compose
- Enables OpenVPN and pulls down NordVPN's ovpn configs
- Works alongside Steam Deck updates and even re-imaging the Deck

![vscode screenshot](https://user-images.githubusercontent.com/364501/184961092-15530648-1ade-4923-bda9-ab3a5cc4a437.png)

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

1. Connect to wifi
2. Go to Power -> Desktop mode
3. Open a Konsole terminal
4. Set up dotfiles managed via the [HackerNews dotfiles strategy](https://news.ycombinator.com/item?id=11070797):

```bash
cd ~
git config --global init.defaultBranch main
git init --bare ~/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config status.showUntrackedFiles no
dotfiles remote add origin https://github.com/hunterloftis/dotfiles.git
dotfiles fetch --all
dotfiles reset --hard origin/main
passwd # choose a password for sudoing on your deck
~/.decksetup.sh
```

If you've already been using podman,
you should `podman network ls` and `podman network rm` any
existing networks, to ensure that they'll be recreated with the podman-dnsname plugin.

Finally, restart your deck.

## Troubleshooting

Podman isn't the most resilient software, but at least it's easy to reset:

```
podman system reset
```
