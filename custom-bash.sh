#!/usr/bin/env bash

PrepareRun() {
cat $1 | grep custom-bash > /dev/null 2>&1
if [ $? == 0 ]; then
    echo -e "\nbash customization has already been applied to user $USER"
    echo -n "do you wanna reset your bash? [y/N]: "
    read reset;
    if ! { [ "$reset" == "y" ] || [ "$reset" == "Y" ]; }; then
        echo ""
        exit 1
    fi
    cp ~/.bash_profile ~/.bash_profile.bkp && cp ~/.bashrc ~/.bashrc.bkp
    rm ~/.bash_profile && rm ~/.bashrc
    touch ~/.bash_profile && touch ~/.bashrc
else
    if [ ! -f ~/.bashrc ]; then touch ~/.bashrc; fi
    if [ ! -f ~/.bash_profile ]; then touch ~/.bash_profile; fi
    if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
    cp ~/.bash_profile ~/.bash_profile.bkp && cp ~/.bashrc ~/.bashrc.bkp
fi
}

DefaultShell() {
if [ $SHELL != "/bin/bash" ]; then
    echo -e "\ndefault shell of user $USER is not bash"
    echo -n "do you wanna change your default shell to bash? [y/N]: "
    read change;
    if [ "$change" == "y" ] || [ "$change" == "Y" ] || [ "$change" == "" ]; then
        chsh -s /bin/bash
        return
    fi
fi
}

ApplyCustomMac() {
echo '
# custom-bash :)
show_branch() {
    local gbranch=$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/[\1]/")
    if [ "$gbranch" != "" ]; then echo "─$(tput bold)$gbranch"; fi
}
if [ $(id -u) == 0 ]; then
    export PS1="\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\[$(tput sgr0)\]\$(show_branch)\[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[91m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
else
    export PS1="\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\[$(tput sgr0)\]\$(show_branch)\[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[92m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
fi
' >> ~/.bash_profile
echo '
# custom-bash :)
show_branch() {
    local gbranch=$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/[\1]/")
    if [ "$gbranch" != "" ]; then echo "─$(tput bold)$gbranch"; fi
}
export PS1="\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\[$(tput sgr0)\]\$(show_branch)\[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[92m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
' >> ~/.bashrc
echo '
set completion-ignore-case On
alias ls="ls -G"
alias ll="ls -lhaC" 
alias grep="grep --color=always"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export HISTTIMEFORMAT="%d/%m/%y %T " 
' | tee -a ~/.bash_profile ~/.bashrc > /dev/null
echo 'set completion-ignore-case On' >> ~/.inputrc
}

ApplyCustomLinux() {
echo '
# custom-bash :)
show_branch() {
    local gbranch=$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/[\1]/")
    if [ "$gbranch" != "" ]; then echo "─$(tput bold)$gbranch"; fi
}
if [ $(id -u) == 0 ]; then
    export PS1="\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\[$(tput sgr0)\]\$(show_branch)\[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[91m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
else
    export PS1="\[$(tput sgr0)\]┌─\[$(tput bold)\](\u@\h)\[$(tput sgr0)\]─\[$(tput bold)\][\w]\[$(tput sgr0)\]\$(show_branch)\[$(tput sgr0)\]\n└─\[$(tput sgr0)\]\[$(tput bold)\]\[\033[92m\]\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
fi
set completion-ignore-case On
alias ls="ls --color=auto"
alias ll="ls -lhaC" 
alias grep="grep --color=auto" 
alias diff="diff --color=auto"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export HISTTIMEFORMAT="%d/%m/%y %T "
' >> ~/.bashrc
echo 'set completion-ignore-case On' >> ~/.inputrc
}

if [[ $OSTYPE == "linux-gnu" ]]; then
    bash_file=~/.bashrc
    PrepareRun $bash_file
    DefaultShell
    ApplyCustomLinux
else
    bash_file=~/.bash_profile
    PrepareRun $bash_file
    DefaultShell
    ApplyCustomMac
fi

source ~/.bash_profile
source ~/.bashrc

echo -e "\nrestart the terminal to apply the modifications\n"