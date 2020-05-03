# System default
# --------------------------------------------------------------------

[ -z ${PLATFORM+x} ] && export PLATFORM=$(uname -s)

# Make nice and powerful bash prompt
export PS1="\n\[\e[1;30m\][\[\e[0;37m\]$$:$PPID - \j:\!\[\e[1;30m\]]\[\e[0;36m\] \T \[\e[1;30m\][\[\e[0;34m\]\u\[\e[0;32m\]@\H \[\e[0;35m\]+${SHLVL}\[\e[1;30m\]] \[\e[0;37m\]\w\[\e[0;0m\] \n--> "

#Enable colors on terminal
export CLICOLOR=1

#Add executables to path
export PATH="$PATH:$HOME/bin"

#UTF-8
export LANG=en_US.UTF-8

if [ "$PLATFORM" = 'Darwin' ]; then
	#Set iTerm2 tab name to current working directory
	export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007";'
fi

# Alias
#alias ls='ls --hide="*.pyc"'
alias dotfiles='cd ~/repos/personal/dotfiles; py3workspace'
alias jupyterlab='cd ~/repos/personal/jupyterlab; pipenv run jupyter-lab'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd.='cd ..'
alias cd..='cd ..'
alias l='ls -alF'
alias ll='ls -l'

#
export EDITOR="vim"

# FZF keybindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# pyenv 
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
