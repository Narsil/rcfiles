#!/bin/sh
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

git submodule --init update
git submodule foreach git submodule --init update

cd $HOME/.vim/bundle/command-t/
rake make
cd $HOME
