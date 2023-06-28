[[ -z $DISPLAY && XDG_VTNR -eq 1 ]] && exec startx
if [ -f $HOME/.bashrc ]; then
	source $HOME/.bashrc
fi


export PATH="$HOME/.cargo/bin:$PATH"
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
