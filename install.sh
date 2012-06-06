#!/bin/sh

cd $(dirname $0)

# install sudo
aptitude install sudo

# install git
aptitude install git
adduser --system --shell $(which git-shell) --gecos 'git version control' --group --disabled-password --home /home/git git

# install gitolite
aptitude install gitolite

# move repo to gitolite repos


# add repo to gitolite config

# TODO make install script only consist of the below and the rest is cfengine

# add post-update hook to repo

# install cfengine inputs
