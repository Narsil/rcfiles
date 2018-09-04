# ~/.bashrc: executed by bash(1) for non-login shells.

export PS1='\h:\w\$ '
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
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


if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -f $HOME/.django_bash_completion ]; then
    . $HOME/.django_bash_completion
fi

PS1='\n\[\033[1;36m\](\A) \[\033[1;32m\]\u\[\033[0;36m@\]\[\033[1;31m\]\h \[\033[01;34m\]\W \n\$ \[\033[00m\]'
#PS1='\e[1;36m(\A)\e[1;32m\u\e[0;36m@\e[1;31m\h \e[1;34m\w$ \e[0m\]'
#PS1="\[\033[0;37;44m\u@\033[0;32;43m\h:\033[0;33;41m\w$\033[0m\]"

export WORKON_HOME=$HOME/src
# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it
function workon_cwd {
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? == 0 ]; then
        # Find the repo root and check for virtualenv name override
        GIT_DIR=`\cd $GIT_DIR; pwd`
        PROJECT_ROOT=`dirname "$GIT_DIR"`
        ENV_NAME="`basename $PROJECT_ROOT`/venv"
        # Activate the environment only if it is not already active
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                source "$WORKON_HOME/$ENV_NAME/bin/activate" && export CD_VIRTUAL_ENV="$ENV_NAME"
            fi
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    cd "$@" && workon_cwd
}
alias cd="venv_cd"
