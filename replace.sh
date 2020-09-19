#!/bin/bash
# Absolute path this script is in. /home/user/bin
set -x
os=`uname`
if [[ "$os" == "Linux" ]]; then
    read='readlink'
    NVIM_COMMAND="sudo apt install neovim"
    MINICONDA=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
else
    # for macOS
    read='greadlink'
    NVIM_COMMAND="brew install neovim"
    MINICONDA=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOS-x86_64.sh
fi
SCRIPT=`$read -f $0`
echo $SCRIPT
SCRIPTPATH=`dirname $SCRIPT`
echo $SCRIPTPATH

# Bashrc files.
cd $SCRIPTPATH
for file in .bashrc .bash_profile
do
    echo ""
    echo "Replacing $file"
    cd ~
    rm -rf $file
    ln -s $SCRIPTPATH/$file
done

# Install neovim
if ! command -v nvim &> /dev/null
then
    $(NVIM_COMMAND)
    # Special treatment for neovim config

fi

if test -f "$SCRIPTPATH/init.vim"; then
    cd ~/.config
    mkdir nvim
    cd nvim
    ln -s $SCRIPTPATH/init.vim


    # Vim plug
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    # We don't have vim alias yet.
    nvim +PlugInstall +qall
fi


# Install miniconda3
if ! command -v conda &> /dev/null
then
    wget $MINICONDA
    sh $MINICONDA
fi

# Install rust for rust-analyzer
if ! command -v rustup &> /dev/null
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! command -v rust-analyzer &> /dev/null
then
    cd ~/src
    git clone https://github.com/rust-analyzer/rust-analyzer.git && cd rust-analyzer
    cargo xtask install --server
fi

