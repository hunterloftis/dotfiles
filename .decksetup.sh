#!/usr/bin/env bash
set -euxo pipefail

# Idempotent deck setup script
# Expects to live with other dotfiles:
# - ~/.bashrc
# - ~/.bash_profile
# - ~/.config/systemd/user/ssh-agent.service
# - ~/.flat/docker
# - ~/.flat/docker-compose

# references
# https://fedoramagazine.org/use-docker-compose-with-podman-to-orchestrate-containers-on-fedora/

cleanup() {
  trap - SIGINT SIGTERM ERR
  # script cleanup here
  sudo steamos-readonly enable
}

# make sure a password has been set
set +x
echo "run 'passwd' to set a password, if you haven't already"
set -x
sudo whoami

trap cleanup SIGINT SIGTERM ERR

# DANGER ZONE
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syy
# install packages
sudo pacman -S --noconfirm networkmanager-openvpn podman podman-docker python-pip
sudo touch /etc/subuid
sudo usermod --add-subuids 10000-75535 deck
sudo touch /etc/subgid
sudo usermod --add-subgids 10000-75535 deck
# add docker.io as a registry since redhat is silly
sudo sh -c "printf \"[registries.search]\\nregistries = ['docker.io']\\n\" > /etc/containers/registries.conf"
# allow flatpak to access /tmp & docker.sock, required for vscode devcontainers
sudo flatpak override --filesystem=/tmp
# https://github.com/flathub/com.visualstudio.code/issues/55#issuecomment-541975985
# /run/user instead of /run/docker.sock because podman's DOCKER_HOST is /run/user/$UID/podman/podman.sock
sudo flatpak override --filesystem=/run/user/1000/podman/podman.sock com.visualstudio.code
sudo flatpak override --env=DOCKER_HOST=unix:///run/user/1000/podman/podman.sock com.visualstudio.code
# /DANGER ZONE
sudo steamos-readonly enable

# required to use the uids set above
podman system migrate

# set up podman socket to work with docker-compose
systemctl --user enable --now podman.socket
systemctl --user status podman.socket

# install podman-compose
# pip3 install podman-compose
# pip3 install git+https://github.com/containers/podman-compose.git@devel

# https://github.com/containers/podman/issues/11822#issuecomment-932289679
pip3 install docker-compose==1.29.2

# install vscode, chrome, godot
flatpak update -y
flatpak install -y org.chromium.Chromium
flatpak install -y com.visualstudio.code
flatpak install -y org.godotengine.Godot
xdg-settings set default-web-browser org.chromium.Chromium.desktop

# install vscode extensions
export $(dbus-launch)
flatpak run --branch=stable --arch=x86_64 --command=code --file-forwarding com.visualstudio.code --reuse-window --install-extension ms-vscode-remote.remote-containers

# download NordVPN's openvpn configs
mkdir -p ~/ovpn
sudo curl https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip --output /tmp/ovpn.zip
unzip -q -o /tmp/ovpn.zip -d ~/ovpn

# uncomment to auto-open bitwarden install URL
# xdg-open https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb?hl=en

# make some directories in $HOME
mkdir -p ~/code ~/test

# ssh-agent
# requires ~/.config/systemd/user/ssh-agent.service
# requires export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket" in ~/.bashrc
systemctl --user enable --now ssh-agent

# configure git
git config --global user.name "Hunter Loftis"
git config --global user.email hunter@hunterloftis.com
git config --global core.editor "nano"
git config --global pull.ff only

# configure keyboard
setxkbmap -option 'ctrl:swap_lalt_lctl'

# TODO: load a KDE hotkey config file (with swapped ctrl + alt and other things)
# TODO: load a KDE keyboard repeat speed config
# TODO: load a KDE fx (wobbly windows etc) config

set +x
echo
echo
echo 'Manual TODOs:'
echo
echo '  1. install bitwarden: https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb?hl=en'
echo '  2. via bitwarden, copy your SSH keys into ~/.ssh'
echo '  3. chmod 600 ~/.ssh/* && chmod 700 ~/.ssh'
echo '  4. open network connection settings and add a new VPN connection using a file in ~/ovpn/udp'
echo '  5. open settings and load shortcuts from ~/shortcuts.kksrc'
echo

