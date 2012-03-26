#!/bin/sh

sudo apt-get install ruby-dev rake rubygems pep8
sudo pip install -e git+git://github.com/kevinw/pyflakes.git#egg=pyflakes

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

for file in .vimrc .bashrc .vim .django_bash_completion
do
    echo "Replacing $file"
    cd $HOME
    rm -rf $file
    ln -s $SCRIPTPATH/$file
done

cd $SCRIPTPATH
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update

cd $HOME/.vim/bundle/command-t/
rake make
cd $SCRIPTPATH
