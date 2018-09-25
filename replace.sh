#!/bin/bash
# Absolute path this script is in. /home/user/bin
os=`uname`
if [[ "$os" == "Linux" ]]; then
    read='readlink'
else
    # for macOS
    read='greadlink'
fi
SCRIPT=`$read -f $0`
SCRIPTPATH=`dirname $SCRIPT`

for file in .vimrc .bashrc .bash_profile
do
    echo "Replacing $file"
    cd ~
    rm -rf $file
    ln -s $SCRIPTPATH/$file
    echo $SCRIPTPATH
done

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
