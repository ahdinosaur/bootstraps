#!/bin/sh

DIR="$( cd $( dirname $0 ) && pwd )"

echo "installing sudo"
aptitude install -y sudo

echo "installing git"
aptitude install -y git
echo "adding git user"
adduser --system --shell $(which git-shell) --gecos 'git version control' --group --disabled-password --home /home/git git

echo "making hackercoop user"
adduser --shell /bin/bash --gecos 'hacker coop' --home /home/hackercoop hackercoop
echo "generating ssh keys for hackercoop user"
cd "/home/hackercoop/"
sudo -H -u hackercoop mkdir .ssh
sudo -H -u hackercoop ssh-keygen -t rsa -b 2048 -P "" -f ".ssh/id_rsa"
echo "copying ssh keys for hackercoop user to git homedir"
cp "/home/hackercoop/.ssh/id_rsa.pub" "/home/git/hackercoop.pub"

# install gitolite
echo "installing gitolite"
cd "/home/git/"
sudo -H -u git mkdir bin
sudo -H -u git git clone git://github.com/sitaramc/gitolite
sudo -H -u git gitolite/install -ln
chown git:git "hackercoop.pub"
sudo -H -u git bin/gitolite setup -pk "hackercoop.pub"

# move repo to gitolite repos
git clone --mirror $(dirname $0) "/home/git/repositories/$(basename $DIR).git"
sudo -H -u git chown -R git:git "/home/git/repositories/$(basename $DIR).git"
sudo -H -u git bin/gitolite setup

# add repo to gitolite config
echo "configuring gitolite"
cd "/home/hackercoop"
sudo -H -u hackercoop git clone git@localhost:gitolite-admin.git
cd "gitolite-admin"



# TODO make install script only consist of the below and the rest is cfengine

# add post-update hook to repo

# install cfengine inputs
