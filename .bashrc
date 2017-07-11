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
alias ssh='ssh -X'
alias serve="python -c \"import SimpleHTTPServer; m = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map; m[''] = 'text/plain'; m.update(dict([(k, v + ';charset=UTF-8') for k, v in m.items()])); SimpleHTTPServer.test();\""
alias unity-control-center="export XDG_CURRENT_DESKTOP=Unity; unity-control-center"
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
export PATH=$PATH:$HOME/src/android-sdk-linux/platform-tools/
export PATH=$PATH:$HOME/src/android-sdk-linux/tools/
# export PATH=$PATH:$HOME/src/google_appengine/
export PATH=/var/lib/gems/1.8/bin:$PATH

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

export EC2_KEYPAIR=kwyk # name only, not the file name

export EC2_URL=https://ec2.eu-west-1.amazonaws.com
export EC2_REGION=eu-west-1

export EC2_PRIVATE_KEY=$HOME/.amazon/pk-QTET2ZBRFXVCJ3HQ63PATFYNMDOTUP7E.pem
export EC2_CERT=$HOME/.amazon/cert-QTET2ZBRFXVCJ3HQ63PATFYNMDOTUP7E.pem

export AWS_AUTO_SCALING_HOME=$HOME/src/AutoScaling-1.0.49.1
export PATH=$PATH:$AWS_AUTO_SCALING_HOME/bin/

export AWS_ELB_HOME=$HOME/src/ElasticLoadBalancing-1.0.17.0
export PATH=$PATH:$AWS_ELB_HOME/bin/

export AWS_CLOUDWATCH_HOME=$HOME/src/CloudWatch-1.0.12.1
export PATH=$PATH:$AWS_CLOUDWATCH_HOME/bin/

export JAVA_HOME=/usr/lib/jvm/java-6-sun/

export GOROOT=$HOME/src/go
export GOOS=linux
export GOARCH=386
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN
export CLOJURESCRIPT_HOME=$HOME/src/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin
export PATH=$PATH:$HOME/bin/Sublime\ Text\ 2/
export PATH=$PATH:$HOME/src/phantomjs/bin/
export PATH=$PATH:$HOME/src/depot_tools/
export PATH=$PATH:$HOME/src/AWS-ElasticBeanstalk-CLI-2.1/eb/linux/python2.7/
export PATH=$PATH:$HOME/src/Isabelle2013/bin/
