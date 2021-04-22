#!/bin/bash
set -x
# where all my code goes
mkdir ~/Code

sudo apt update
sudo apt upgrade
# install my stuff
sudo apt install xclip libfreetype6-dev libfontconfig1-dev \
    tree zsh emacs git fonts-powerline ripgrep build-essential \
    apt-transport-https ca-certificates \
    curl pkg-config libxcb-xfixes0-dev python3 \
    gnupg lsb-release gzip

# gpg
chown -R $(whoami) ~/.gnupg/
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;

# ssh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

chown -R $(whoami) ~/.ssh/
# set local file permissions
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub


# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# build and install alacritty
git clone https://github.com/jwilm/alacritty ~/Code/
cd ~/Code/alacritty
rustup override set stable
rustup update stable
cargo build --release
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
cd ~/Code
# install go
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
curl -o go1.16.3.linux-amd64.tar.gz https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz

# install oh my zsh
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# make my commit
rm ~/.zshrc
rm -rf ~/.emacs.d
ln ~/Code/dotfiles/zsh/.zshrc .zshrc
ln -s ~/Code/dotfiles/alacritty/ ~/.config/alacritty
ln -s ~/Code/dotfiles/emacs/.doom.d/ ~/.doom.d

# git config
git config --global user.name 'sasidakh'
git config --global user.email 'akhilsasidharan1991@gmail.com'

# install doom emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
yes | ~/.emacs.d/bin/doom install

# install docker 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt install docker-ce docker-ce-cli containerd.io

sudo groupadd docker

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

newgrp docker

# install mongo container
docker pull mongo
docker network create mongo-cluster-dev
docker run -d --net mongo-cluster-dev -p 27017:27017 --name mongoset1 mongo mongod --replSet mongodb-replicaset --port 27017
docker run -d --net mongo-cluster-dev -p 27018:27018 --name mongoset2 mongo mongod --replSet mongodb-replicaset --port 27018
docker run -d --net mongo-cluster-dev -p 27019:27019 --name mongoset3 mongo mongod --replSet mongodb-replicaset --port 27019

# install mongosh
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64  ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt update
sudo apt install mongosh

# tools
cd ~/Downloads
curl -o Insomnia.Core-2021.2.2.deb https://github.com/Kong/insomnia/releases/download/core%402021.2.2/Insomnia.Core-2021.2.2.deb
sudo dpkg -i Insomnia.Core-2021.2.2.deb
curl -o slack-desktop-4.14.0-amd64.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-4.14.0-amd64.deb
sudo dpkg -i slack-desktop-4.14.0-amd64.deb
curl -o postman.tar.gz https://dl.pstmn.io/download/latest/linux64
tzr -xzf postman
