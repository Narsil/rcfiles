#!/bin/sh
# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

for file in .vimrc .bashrc .django_bash_completion
do
    echo "Replacing $file"
    cd $HOME
    rm -rf $file
    ln -s $SCRIPTPATH/$file
done

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
