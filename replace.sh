#!/bin/sh

sudo apt-get install ruby-dev rake rubygems pyflakes pep8

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

for file in .vimrc .bashrc .vim
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
