#!/bin/sh

# TODO make install script use more cfengine

DIR="$( cd $( dirname $0 ) && pwd )"

echo "installing sudo and openssh-server"
aptitude install -y sudo openssh-server

echo "adding git user"
adduser --system --shell $(which git-shell) --gecos 'git version control' --group --disabled-password --home /home/git git

echo "making hackercoop user"
adduser --shell /bin/bash --gecos 'hacker coop' --home /home/hackercoop hackercoop
sudo -H -u hackercoop git config --global user.name "hacker coop"
sudo -H -u hackercoop git config --global user.email "hackercoop@gmail.com"
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
rm "hackercoop.pub"

echo "configuring gitolite"
cd "/home/hackercoop"
sudo -H -u hackercoop git clone git@localhost:gitolite-admin.git
cd "gitolite-admin"
sudo -H -u hackercoop cat > "conf/gitolite.conf" << EOM
@admins = hackercoop

@controls = gitolite-admin cfengine-admin
@public = testing

repo @controls
    RW+     =   @admins
    R       =   @users

repo @public
    RW+     =   @all
EOM
sudo -H -u hackercoop git commit -a -m "configured gitolite for hackercoop."
sudo -H -u hackercoop git push -u origin master
cd ..

echo "installing cfengine"

#chown -R git:git /var/cfengine/inputs/

echo "setting up cfengine-admin.git"
sudo -H -u hackercoop git clone git@localhost:cfengine-admin.git
cd "cfengine-admin"
sudo -H -u hackercoop cp -r "$DIR/inputs" .
sudo -H -u hackercoop chmod +x post-receive
sudo -H -u hackercoop cp post-receive .git/hooks/
sudo -H -u hackercoop
sudo -H -u hackercoop git commit -a -m "configured cfengine for hackercoop."
sudo -H -u hackercoop git push -u origin master
cd ..

# add post-update hook to repo

# install cfengine inputs
