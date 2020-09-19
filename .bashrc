export PS1='\h:\w\$ '
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
os=`uname`
if [[ "$os" == "Linux" ]]; then
    LS_OPTIONS='--color=auto'
else
    LS_OPTIONS='-G'
fi
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias s='cd ..'
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias grep='grep $LS_OPTIONS'
# alias ssh='ssh -X'
alias serve="python -c \"import SimpleHTTPServer; m = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map; m[''] = 'text/plain'; m.update(dict([(k, v + ';charset=UTF-8') for k, v in m.items()])); SimpleHTTPServer.test();\""
alias gnome-control-center="env XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
# alias cp='cp -i'
# alias mv='mv -i'
alias vim='nvim'


if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

PS1='\n\[\033[1;36m\](\A) \[\033[1;32m\]\u\[\033[0;36m@\]\[\033[1;31m\]\h \[\033[01;34m\]\W \n\$ \[\033[00m\]'
#PS1='\e[1;36m(\A)\e[1;32m\u\e[0;36m@\e[1;31m\h \e[1;34m\w$ \e[0m\]'
#PS1="\[\033[0;37;44m\u@\033[0;32;43m\h:\033[0;33;41m\w$\033[0m\]"


# .condaauto.sh automatically activates a conda environment when enterring
# a folder that contains a .condaauto file. The first line in the .condaauto
# file is the name of the conda environment.
#
# To make this work you have to source .condaauto.sh in your bashrc or
# equivalent.
#
# I feel sorry for my bash foo :(

function _conda_auto_activate() {
  if [ -e ".condaauto" ]; then
    # echo ".condaauto file found"
    ENV=$(head -n 1 .condaauto)

    # Check to see if already activated to avoid redundant activating
    if [[ $PATH == *"$ENV"* ]]; then
      echo "Conda env '$ENV' already activated."
    else
      source activate $ENV
    fi
    export CD_VIRTUAL_ENV="$ENV"
  elif [ $CD_VIRTUAL_ENV ]; then
      conda deactivate && unset CD_VIRTUAL_ENV
  fi
}
function venv_cd() {
  if command -v deactivate &> /dev/null
  then
    deactivate
  fi

  builtin cd "$@"

  if [[ -d ./.venv ]] ; then
    . ./.venv/bin/activate
  fi
}

# function venv_cd() {
#     cd "$@" && _conda_auto_activate
# }
alias cd="venv_cd"
# added by Miniconda3 installer
# export PATH="$HOME/src/miniconda3/bin:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nicolas/src/google-cloud-sdk/path.bash.inc' ]; then source '/Users/nicolas/src/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nicolas/src/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/nicolas/src/google-cloud-sdk/completion.bash.inc'; fi
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$PATH:$HOME/bin"


complete -C /home/nicolas/bin/terraform terraform
