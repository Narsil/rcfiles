if [ -f $HOME/.bashrc ]; then
	source $HOME/.bashrc
fi

_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
