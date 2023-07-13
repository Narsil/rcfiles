[[ -z $DISPLAY && XDG_VTNR -eq 1 ]] && exec startx
if [ -f $HOME/.bashrc ]; then
	source $HOME/.bashrc
fi


. "$HOME/.cargo/env"
