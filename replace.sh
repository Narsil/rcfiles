#!/bin/sh
# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

for file in .vimrc .bashrc
do
    echo "Replacing $file"
    cd $HOME
    rm -f $file
    ln -s $SCRIPTPATH/$file
done
