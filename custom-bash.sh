#!/usr/bin/env bash

PrepareRun() {
cat ~/.bash_profile | grep mac8028 > /dev/null 2>&1
if [ $? == 0 ]; then
    echo ""
    echo "bash customization has already been applied to user $USER"
    echo -n "do you wanna reset your bash? [y/N]: "
    read reset;
    echo ""
    # if [[ $reset == "y" ]] || [[ $reset == "Y" ]]; then
    if ! { [ "$reset" == "y" ] || [ "$reset" == "Y" ]; }; then
        exit 1
    fi
    cp ~/.bash_profile ~/.bash_profile.bkp && cp ~/.bashrc ~/.bashrc.bkp
    rm ~/.bash_profile && rm ~/.bashrc
    touch ~/.bash_profile && touch ~/.bashrc
else
    if [ ! -f ~/.bashrc ]; then
        touch ~/.bashrc
    fi
    if [ ! -f ~/.bash_profile ]; then
        touch ~/.bash_profile
    fi
    cp ~/.bash_profile ~/.bash_profile.bkp && cp ~/.bashrc ~/.bashrc.bkp
fi
}

DefaultShell() {
shell="$SHELL"
if [ $shell != "/bin/bash" ]
then
    echo -e "default shell of user $USER is zsh"
    echo -n "do you wanna change your default shell to bash? [y/N]: "
    read change;
    echo ""
    if [ "$change" == "y" ] || [ "$change" == "Y" ] || [ "$change" == "" ]; then
        echo -e "so now you must enter the username and then enter your password"
        chsh -s /bin/bash
        echo -e "now your default shell is bash"
        echo "if you wanna change to zsh please enter ' chsh -s /bin/zsh ' in the terminal"
        return
    fi
    echo -e "your default shell is zsh"
    echo "if you wanna change to bash please enter ' chsh -s /bin/bash ' in the terminal"
else
    echo ""
    echo -e "default shell of user $USER is bash"
fi
}

ApplyCustom() {
echo "
# mac8028 customize prompt
show_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/─[\1]/'
}
if [ $(id -u) == 0 ]; then
    export PS1='\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\$(show_branch) \[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[91m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]'
else
    export PS1='\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\$(show_branch) \[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[92m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]'
fi
" >> ~/.bash_profile
echo "
# mac8028 customize prompt
show_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/─[\1]/'
}
export PS1='\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\$(show_branch) \[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[93m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]'
" > ~/.bashrc
echo "
# enable lscolor
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
# alias useful
alias ls='ls -G'
alias ll='ls -lhaCF'
alias grep='grep --color=always'
# ignore case
set completion-ignore-case On
# customize man
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
# customize history
export HISTTIMEFORMAT='%d/%m/%y %T '
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
" | tee -a ~/.bash_profile ~/.bashrc > /dev/null
}

PrepareRun
DefaultShell
ApplyCustom
source ~/.bash_profile
source ~/.bashrc

echo "modifications successfully performed, restart the terminal to apply the modifications"
echo ""