#!/bin/sh

# install sudo
aptitude install -y sudo

# install git
aptitude install -y git
adduser --system --shell $(which git-shell) --gecos 'git version control' --group --disabled-password --home /home/git git

# make group user
echo "making hackercoop user"
adduser --shell /bin/bash --gecos 'hacker coop' --home /home/hackercoop hackercoop
cd "/home/hackercoop/"
sudo -H -u hackercoop ssh-keygen -t rsa -b 2048 -P "" -f ".ssh/id_rsa"
cp "/home/hackercoop/.ssh/id_rsa.pub" "/home/git/hackercoop.pub"

# install gitolite
cd "/home/git/"
sudo -H -u git mkdir bin
sudo -H -u git git clone git://github.com/sitaramc/gitolite
sudo -H -u git giolite/install -ln
sudo -H -u git bin/gitolite setup -pk "hackercoop.pub"

# move repo to gitolite repos
git clone --mirror $(dirname $0) "/home/git/repositories/$(basename $0).git"
sudo -H -u git chown -R git:git "/home/git/repositories/$(basename $0).git"
sudo -H -u git bin/gitolite setup

# add repo to gitolite config
sudo -H -u git git clone git@localhost:gitolite-admin.git
cd "gitolite-admin"



# TODO make install script only consist of the below and the rest is cfengine

# add post-update hook to repo

# install cfengine inputs
